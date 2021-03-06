﻿using System;
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
    public partial class InventAdd : System.Web.UI.Page
    {
        public string ListPartnos;
        protected string isvalid;
        protected void Page_Load(object sender, EventArgs e)
        {
            ListPartnos = LoadPartnos();
        }

        public void Button1_Click(Object sender, EventArgs e)
        {
            receipt_no.Text = receiptTXT.Text;

            MultiView1.ActiveViewIndex = 1;
            BindData();
        }

        protected string LoadPartnos()
        {
            StringBuilder sb = new StringBuilder();
            using (App_Data.DataClassesERPDataContext db = new App_Data.DataClassesERPDataContext())
            {
                var query =
                   from ord in db.partnos
                   where ord.@operator == Global.UserEntityID.ToString()
                   //where ord.part_no.StartsWith(PartialPartno)
                   select ord;

                // Execute the query, and change the column values
                // you want to change.
                foreach (App_Data.partno ord in query)
                {
                    sb.Append(Convert.ToString(ord.part_no.Trim()+"-"+ ord.part_name.Trim()+ "|"));
                }

                return Convert.ToString(sb);

            }
        }


        protected void GridView1_OnRowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int idnum = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value.ToString().Trim());

            try
            {
                using (SqlConnection myConnection = new SqlConnection(Global.LiveConnString))
                {

                    using (SqlCommand mycmd1 = new SqlCommand("whreceipt_delSingle", myConnection))
                    {
                        myConnection.Open();
                        mycmd1.CommandType = CommandType.StoredProcedure;

                        SqlParameter myparam = mycmd1.Parameters.Add("RETURN_VALUE", SqlDbType.Int);
                        myparam.Direction = ParameterDirection.ReturnValue;

                        myparam = mycmd1.Parameters.Add("@p_id_num", SqlDbType.NVarChar, 35);
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

        public void LogButton_Click(Object sender, EventArgs e)
        {
            //Request.Form["tel1"].ToString().Trim()
            string tmpPartno = Request.Form["autoText"].ToString().Trim();

            if (tmpPartno == null || tmpPartno == "" || tmpPartno.Length < 1)
            {
                Message.Text = " *** PartNO *** is not allow empty!";
                return;
            }

            tmpPartno = shared.HelperMethods.GetPartNo(tmpPartno);

            try
            {
                using (SqlConnection myConnection = new SqlConnection(Global.LiveConnString))
                {

                    using (SqlCommand mycmd1 = new SqlCommand("whreceipt_input", myConnection))
                    {
                        myConnection.Open();
                        mycmd1.CommandType = CommandType.StoredProcedure;

                        SqlParameter myparam = mycmd1.Parameters.Add("RETURN_VALUE", SqlDbType.Int);
                        myparam.Direction = ParameterDirection.ReturnValue;

                        myparam = mycmd1.Parameters.Add("@p_whreceipt_no", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = receipt_no.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_part_no", SqlDbType.NVarChar, 100);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = tmpPartno;

                        myparam = mycmd1.Parameters.Add("@p_quantity", SqlDbType.NVarChar, 15);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = quantity.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_supplier_code", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = supplier.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_order_no", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = "1234567";

                        myparam = mycmd1.Parameters.Add("@p_podate", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = System.DateTime.Now.ToString("MM/dd/yyyy");

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
                var whreceipt = from whc in db.wh_receipts
                                where whc.whre_no == receipt_no.Text.ToString().Trim() && whc.@operator == tmpUserCode
                                select whc;
                int test = whreceipt.Count();
                foreach (App_Data.wh_receipt twhreceipt in whreceipt)
                {
                    if (twhreceipt.flag == "1")
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
    }
}