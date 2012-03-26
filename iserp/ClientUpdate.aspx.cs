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
    public partial class ClientUpdate : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            client_code.Text = Request.QueryString["IDCnameCode"];
            if (!IsPostBack)
            {
                Load_ErpClient();
            }
        }

        protected void Load_ErpClient()
        {
            string tmpsearchbox = client_code.Text.Trim().ToString();
            using (App_Data.DataClassesERPDataContext erpdb = new App_Data.DataClassesERPDataContext())
            {
                var allClient = from c in erpdb.erpclients
                                where c.cname_code == tmpsearchbox
                                orderby c.cname
                                select c;
                foreach (var tmpclient in allClient)
                {
                    cname.Text = tmpclient.cname.Trim();
                    cperson.Text = tmpclient.contact.Trim();
                    txbTel.Text = tmpclient.tel.Trim();
                    txbFax.Text = tmpclient.fax.Trim();
                    saddress.InnerText = tmpclient.address.Trim();
                    scity.Text = tmpclient.city.Trim();
                    post_code.Text = tmpclient.postcode.Trim();
                    email.Text = tmpclient.email.Trim();
                    invoice_tax.Text = tmpclient.invoice_tax.ToString().Trim();
                    website.Text = tmpclient.website.Trim();
                    notes.InnerText = tmpclient.notes.Trim();
                    CascadingDropDown1.SelectedValue = tmpclient.countryID.ToString().Trim();
                    CascadingDropDown2.SelectedValue = tmpclient.locationID.ToString().Trim();
                }
            }
        }

        public void AddAuthor_Click(Object sender, EventArgs E)
        {
            Message.Text = "";
            //tmpUserCode = Global.myOperator.ToString();

            try
            {
                using (SqlConnection myConnection = new SqlConnection(Global.LiveConnString))
                {

                    using (SqlCommand mycmd1 = new SqlCommand("update_client_all", myConnection))
                    {
                        myConnection.Open();
                        mycmd1.CommandType = CommandType.StoredProcedure;

                        SqlParameter myparam = mycmd1.Parameters.Add("RETURN_VALUE", SqlDbType.Int);
                        myparam.Direction = ParameterDirection.ReturnValue;

                        myparam = mycmd1.Parameters.Add("@p_Cname_code", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = client_code.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_Cname", SqlDbType.NVarChar, 100);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = cname.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_contact", SqlDbType.NVarChar, 85);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = cperson.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_Tel", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = txbTel.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_Fax", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = txbFax.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_Cell", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = ""; // txbFax.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_Address", SqlDbType.NVarChar, 120);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = saddress.InnerText; ;

                        myparam = mycmd1.Parameters.Add("@p_City", SqlDbType.NVarChar, 65);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = scity.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_StateID", SqlDbType.NVarChar, 65);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = DropDownListregion.SelectedValue.ToString().Trim();

                        myparam = mycmd1.Parameters.Add("@p_CountryID", SqlDbType.NVarChar, 65);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = DropDownListcountry.SelectedValue.ToString().Trim();

                        myparam = mycmd1.Parameters.Add("@p_Postcode", SqlDbType.NVarChar, 10);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = post_code.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_Email", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = email.Text.ToString().Trim();

                        myparam = mycmd1.Parameters.Add("@p_invoice_tax", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = invoice_tax.Text.ToString().Trim();

                        myparam = mycmd1.Parameters.Add("@p_Website", SqlDbType.NVarChar, 25);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = website.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_usercode", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = Global.UserEntityID.ToString();

                        myparam = mycmd1.Parameters.Add("@p_Notes", SqlDbType.NText);
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

            Load_ErpClient();
        }

    }
}