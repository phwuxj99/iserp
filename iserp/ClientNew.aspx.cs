/****************************
 * Date Created: Feb 09, 2012
 * Programmer: Stephen Wu 
 ***************************/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

namespace iserp
{
    public partial class ClientNew : System.Web.UI.Page
    {
        protected string tmpUserCode;
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public void AddAuthor_Click(Object sender, EventArgs E)
        {
            Message.Text = "";
            tmpUserCode = Global.myOperator.ToString();
            string tphone = "";
            string Extension = Request.Form["tel4"].ToString().Trim();
            if (Extension == null || Extension.Length == 0)
            { Extension = ""; }
            else { Extension = " Ext " + Extension; }

            tphone = "(" + Request.Form["tel1"].ToString().Trim() + ") " + Request.Form["tel2"].ToString().Trim() + "-" + Request.Form["tel3"].ToString().Trim() + Extension;

            string tfax = "(" + Request.Form["fax1"].ToString().Trim() + ") " + Request.Form["fax2"].ToString().Trim() + "-" + Request.Form["fax3"].ToString().Trim();

            Message.Text = "";

            try
            {
                using (SqlConnection myConnection = new SqlConnection(Global.LiveConnString))
                {

                    using (SqlCommand mycmd1 = new SqlCommand("add_erpclient", myConnection))
                    {
                        myConnection.Open();
                        mycmd1.CommandType = CommandType.StoredProcedure;

                        SqlParameter myparam = mycmd1.Parameters.Add("RETURN_VALUE", SqlDbType.Int);
                        myparam.Direction = ParameterDirection.ReturnValue;

                        myparam = mycmd1.Parameters.Add("@p_company_code", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = client_code.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_company_name", SqlDbType.NVarChar, 100);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = cname.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_contact", SqlDbType.NVarChar, 85);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = cperson.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_phone_number", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = tphone.Trim();

                        myparam = mycmd1.Parameters.Add("@p_fax_number", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = tfax.Trim();

                        myparam = mycmd1.Parameters.Add("@p_address", SqlDbType.NVarChar, 120);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = saddress.InnerText; ;

                        myparam = mycmd1.Parameters.Add("@p_city", SqlDbType.NVarChar, 65);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = scity.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_zipcode", SqlDbType.NVarChar, 10);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = post_code.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_country", SqlDbType.NVarChar, 65);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = DropDownListcountry.SelectedItem.Text.ToString().Trim();

                        myparam = mycmd1.Parameters.Add("@p_region", SqlDbType.NVarChar, 65);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = DropDownListregion.SelectedItem.Text.ToString().Trim();

                        myparam = mycmd1.Parameters.Add("@p_email", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = email.Text.ToString().Trim();

                        myparam = mycmd1.Parameters.Add("@p_invoice_tax", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = invoice_tax.Text.ToString().Trim();

                        myparam = mycmd1.Parameters.Add("@p_website", SqlDbType.NVarChar, 25);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = website.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_usercode", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = Global.UserEntityID.ToString();

                        myparam = mycmd1.Parameters.Add("@p_notes", SqlDbType.NText);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = notes.Value.Trim();

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
            cname.Focus();

        }
    }
}