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
    public partial class InventRecChk : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            BindData();
        }

        protected void BindData()
        {
            string tmpUserCode = Global.UserEntityID.ToString();
            using (App_Data.DataClassesERPDataContext db = new App_Data.DataClassesERPDataContext())
            {
                var whreceipt = from whc in db.wh_receipts
                                where whc.flag != "1" && whc.@operator == tmpUserCode
                                group whc by whc.whre_no into Group
                                select new { Group.Key, podate = Group.Max(whc => whc.op_date) };
                int test = whreceipt.Count();
                if (test > 0)
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

        protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridView1.PageIndex = e.NewPageIndex;
            GridView1.DataBind();
        }

        protected void BacktoPreviousPage(object sender, EventArgs e)
        {
            MultiView1.ActiveViewIndex = 0;
            Message.Text = "";
        }

        public void LoadDetails(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Details")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                string EntitynumberStr = GridView1.DataKeys[index].Value.ToString();
                EntityIDhide.Text = EntitynumberStr;
                receipt_no.Text = EntitynumberStr;
                // int EntitynumberInt = Convert.ToInt32(EntitynumberStr);

                Load_DetailsView(EntitynumberStr);

                MultiView1.ActiveViewIndex = 1;
            }
        }

        protected void Load_DetailsView(string EntitynumberStr)
        {
            string tmpUserCode = Global.UserEntityID.ToString();
            using (App_Data.DataClassesERPDataContext db = new App_Data.DataClassesERPDataContext())
            {
                var whreceipt = from whc in db.wh_receipts
                                where whc.whre_no == EntitynumberStr && whc.@operator == tmpUserCode
                                select whc;
                int test = whreceipt.Count();
                if (test > 0)
                {
                    GridView2.DataSource = whreceipt;
                    GridView2.DataBind();
                }
                else
                {
                    GridView2.DataSource = null;
                    GridView2.DataBind();
                }
            }
        }


        protected void AddtoInventory(object sender, EventArgs e)
        {
            Message.Text = "";

            try
            {
                using (SqlConnection myConnection = new SqlConnection(Global.LiveConnString))
                {
                    using (SqlCommand mycmd1 = new SqlCommand("batch_inventory", myConnection))
                    {
                        myConnection.Open();
                        mycmd1.CommandType = CommandType.StoredProcedure;

                        SqlParameter myparam = mycmd1.Parameters.Add("RETURN_VALUE", SqlDbType.Int);
                        myparam.Direction = ParameterDirection.ReturnValue;

                        myparam = mycmd1.Parameters.Add("@p_whre_no", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = receipt_no.Text.ToString();

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

            MultiView1.ActiveViewIndex = 0;
            Message.Text = "";
            BindData();
        }

    }
}