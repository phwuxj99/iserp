using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Data.Linq;
using System.Text;
using System.Data.Linq.SqlClient;

namespace iserp
{
    public partial class CpoAdd : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                get_DropDownListClient();
                Get_MaxCpoNO();
            }
        }

        public void Button1_Click(Object sender, EventArgs e)
        {
            cpo_no.Text = txbcpono.Text;
            lblCpoCustomer.Text = DropDownListClient.SelectedItem.Text;
            lblCpoCustomerID.Text = DropDownListClient.SelectedItem.Value;

            MultiView1.ActiveViewIndex = 1;
            BindData();
        }


        protected void ClientChangeRegion(object sender, EventArgs e)
        {
            get_DropDownListClient();
            Get_MaxCpoNO();
        }

        private void Get_MaxCpoNO()
        {
            using (App_Data.DataClassesERPDataContext erpdb = new App_Data.DataClassesERPDataContext())
            {
                string maxCpoNo = (from cpo in erpdb.cpos select cpo.cpono).Max();
                txbcpono.Text = (Convert.ToInt32(maxCpoNo) + 1).ToString();
            }
        }

        private void get_DropDownListClient()
        {
            string tmp_country = DropDownListcountry.SelectedItem.Value.Trim();
            string tmp_region = DropDownListregion.SelectedItem.Value.Trim();

            if (tmp_region == null || tmp_region.Length == 0)
            { tmp_region = null; }
            DropDownListClient.DataSource = null;
            using (App_Data.DataClassesERPDataContext erpdb = new App_Data.DataClassesERPDataContext())
            {

                var ddregion = from rg in erpdb.erpclients
                               where rg.countryID.ToString() == tmp_country && rg.locationID.ToString() == tmp_region && rg.@operator == Global.UserEntityID.ToString()
                               orderby rg.cname
                               select new { rg.cname, rg.cname_code };
                DropDownListClient.DataSource = ddregion;
                DropDownListClient.DataTextField = "cname";
                DropDownListClient.DataValueField = "cname_code";
                DropDownListClient.DataBind();
            }
        }

        public void ButtonAddCpo_Click(Object sender, EventArgs e)
        {
            if (cpo_no.Text.ToString() == "" || cpo_no.Text.ToString().Length < 1)
            {
                Message.Text = "CPO # is empty!";
                return;
            }

            try
            {
                string tmpPartNo = txbSearchKeyword.Text.ToString();
                tmpPartNo = shared.HelperMethods.GetPartNo(tmpPartNo);

                using (SqlConnection myConnection = new SqlConnection(Global.LiveConnString))
                {
                    using (SqlCommand mycmd1 = new SqlCommand("cpo_add", myConnection))
                    {
                        myConnection.Open();
                        mycmd1.CommandType = CommandType.StoredProcedure;

                        SqlParameter myparam = mycmd1.Parameters.Add("RETURN_VALUE", SqlDbType.Int);
                        myparam.Direction = ParameterDirection.ReturnValue;

                        myparam = mycmd1.Parameters.Add("@p_cpono", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = cpo_no.Text.ToString();

                        myparam = mycmd1.Parameters.Add("@p_cnamecode", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = lblCpoCustomerID.Text.ToString();

                        myparam = mycmd1.Parameters.Add("@p_partno", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = tmpPartNo;

                        myparam = mycmd1.Parameters.Add("@p_qty", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = txbQty.Text.ToString();

                        myparam = mycmd1.Parameters.Add("@p_soprice", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = txbPrice.Text.ToString();

                        myparam = mycmd1.Parameters.Add("@p_usercode", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = Global.UserEntityID.ToString();

                        myparam = mycmd1.Parameters.Add("@isvalid", SqlDbType.NVarChar, 253);
                        myparam.Direction = ParameterDirection.Output;


                        using (SqlDataReader myreader = mycmd1.ExecuteReader())
                        {

                            if (((int)(mycmd1.Parameters["RETURN_VALUE"].Value)) == 0)
                            {
                                Message.Text = (string)(mycmd1.Parameters["@isvalid"].Value);
                            }
                            else
                            {
                                Message.Text = (string)(mycmd1.Parameters["@isvalid"].Value);
                                Message.Style["color"] = "red";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Message.Text = ex.Message;
            }
            BindData();
        }


        protected void BindData()
        {
            string tmpUserCode = Global.UserEntityID.ToString();
            int tflag = 0;
            using (App_Data.DataClassesERPDataContext db = new App_Data.DataClassesERPDataContext())
            {
                var whreceipt = from whc in db.cpos
                                where whc.cpono == cpo_no.Text.ToString().Trim() && whc.@operator == tmpUserCode
                                select whc;
                int test = whreceipt.Count();
                foreach (App_Data.cpo twhreceipt in whreceipt)
                {
                    if (twhreceipt.finished.ToString() == "1")
                    {
                        tflag = 1;
                        Message.Text = "Do not use the exist NO.!";
                        break;
                    }
                }

                if (test > 0 && tflag == 0)
                {
                    GridView1.DataSource = whreceipt;
                    GridView1.DataBind();
                }
                else
                {
                    GridView1.DataSource = null;
                    GridView1.DataBind();
                }
            }
        }

        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            AddConfirmDelete((GridView)sender, e);
        }

        /// <summary>
        ///      If the gridview has AutoGenerateDeleteButton set to true, then
        ///      it add a confirm message to the delete buttons.
        ///      This function should be called in the RowDataBound event
        /// </summary>
        protected static void AddConfirmDelete(GridView gv, GridViewRowEventArgs e)
        {
            // Make sure we have the delete button showing.
            if (gv.AutoGenerateDeleteButton != true)
                return;

            // Make sure we are processing a DataRow
            if (e.Row.RowType != DataControlRowType.DataRow)
                return;

            // Search for the Delete button
            foreach (DataControlFieldCell dcf in e.Row.Cells)
            {
                // The header for the LinkButton is normally empty.
                if (dcf.Text == "")
                {
                    // Search the list of control and file the Delete link
                    foreach (Control ctrl in dcf.Controls)
                    {
                        LinkButton deleteButton = ctrl as LinkButton;
                        if (deleteButton != null && deleteButton.Text == "Delete")
                        {
                            deleteButton.Attributes.Add("onClick", "javascript:return " +
                            "confirm('Are you sure you want to delete this Part " +
                            DataBinder.Eval(e.Row.DataItem, "part_no") + " ?');");
                            //"?');");
                            break;
                        }
                    }
                    break;
                }
            }
        }



        protected void GridView1_OnRowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int idnum = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value.ToString().Trim());

            try
            {
                using (SqlConnection myConnection = new SqlConnection(Global.LiveConnString))
                {

                    using (SqlCommand mycmd1 = new SqlCommand("cpo_Singledelete", myConnection))
                    {
                        myConnection.Open();
                        mycmd1.CommandType = CommandType.StoredProcedure;

                        SqlParameter myparam = mycmd1.Parameters.Add("RETURN_VALUE", SqlDbType.Int);
                        myparam.Direction = ParameterDirection.ReturnValue;

                        myparam = mycmd1.Parameters.Add("@p_idnum", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = idnum.ToString();

                        myparam = mycmd1.Parameters.Add("@p_usercode", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = Global.UserEntityID.ToString();

                        myparam = mycmd1.Parameters.Add("@isvalid", SqlDbType.NVarChar, 253);
                        myparam.Direction = ParameterDirection.Output;


                        using (SqlDataReader myreader = mycmd1.ExecuteReader())
                        {

                            if (((int)(mycmd1.Parameters["RETURN_VALUE"].Value)) == 0)
                            {
                                Message.Text = (string)(mycmd1.Parameters["@isvalid"].Value);
                            }
                            else
                            {
                                Message.Text = (string)(mycmd1.Parameters["@isvalid"].Value);
                                Message.Style["color"] = "red";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Message.Text = ex.Message;
            }
            BindData();
        }

        protected void Load_PartNo()
        {
            string tmpsearchbox = txbSearchKeyword.Text.Trim().ToString();
            tmpsearchbox = shared.HelperMethods.GetPartNo(tmpsearchbox);
            LblPartNo.Text = tmpsearchbox;
            using (App_Data.DataClassesERPDataContext erpdb = new App_Data.DataClassesERPDataContext())
            {
                //Search PartNo
                var allPartNo = (from p in erpdb.partnos
                                where p.part_no == tmpsearchbox & p.@operator==Global.UserEntityID.ToString()
                                select p).Single();

                LblPrice.Text = allPartNo.price1.ToString();
                LblName.Text = allPartNo.part_name.ToString();
                txbPrice.Text = allPartNo.price1.ToString();

                //Search Warehouse Qty
                var allPartNo1 = from p in erpdb.warehouses
                                 where p.part_no == tmpsearchbox & p.@operator == Global.UserEntityID.ToString()
                                 select p;

                if (allPartNo1.Count() > 0)
                {
                    foreach (var ord in allPartNo1)
                    {
                        LblInv.Text = ord.qty.ToString();                        
                    }
                }
                else
                {
                    LblInv.Text = "0";
                }
            }
        }

        protected void Search_Click(object sender, EventArgs e)
        {
            Load_PartNo();
        }

        protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridView1.PageIndex = e.NewPageIndex;
            GridView1.DataBind();
        }

        public void ButtonAddINV_Click(Object sender, EventArgs e)
        {
            if (cpo_no.Text.ToString() == "" || cpo_no.Text.ToString().Length < 1)
            {
                Message.Text = "CPO # is empty!";
                return;
            }
        }

    }
}