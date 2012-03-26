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
    public partial class AdminUsersList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                Load_GridView();
        }

        protected void Load_GridView()
        {
            string tmpUserCode = Global.UserEntityID.ToString();
            using (App_Data.DataClassesERPDataContext erpdb = new App_Data.DataClassesERPDataContext())
            {
                var allClient = from c in erpdb.users_infos
                                orderby c.users_code
                                select c;

                GridView1.DataSource = allClient;
                GridView1.DataBind();
            }
        }

        protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridView1.PageIndex = e.NewPageIndex;
            GridView1.DataBind();
        }

        public void UserProfile(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "UserProfile")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                string userstmp = GridView1.DataKeys[index].Value.ToString();
                EntityIDhide.Text = userstmp;

                Load_DetailsView(userstmp);

                MultiView1.ActiveViewIndex = 1;
            }
        }


        protected void Load_DetailsView(string TransFeeID)
        {
            using (App_Data.DataClassesERPDataContext erpdb = new App_Data.DataClassesERPDataContext())
            {
                var SingleUser = from c in erpdb.users_infos
                                 where c.users_code == TransFeeID // & c.@operator == Global.UserEntityID.ToString()
                                 select c;

                FormView1.DataSource = SingleUser;
                FormView1.DataBind();
            }
        }

        protected void FormView1_ItemCommand(object sender, FormViewCommandEventArgs e)
        {
            if (e.CommandName.Equals("Edit"))
                FormView1.ChangeMode(FormViewMode.Edit);
            else if (e.CommandName.Equals("New"))
                FormView1.ChangeMode(FormViewMode.Insert);
            else if (e.CommandName.Equals("Cancel"))
                FormView1.ChangeMode(FormViewMode.ReadOnly);
            else if (e.CommandName.Equals("Update"))
                UpdateFormView();
            //else if (e.CommandName.Equals("Insert"))
            // InsertFormView();
        }

        protected void FormView1_Inserting(object sender, FormViewInsertEventArgs e)
        {
        }

        protected void FormView1_ItemUpdating(object sender, FormViewUpdateEventArgs e)
        {
        }

        protected void FormView1_ModeChanged(object sender, EventArgs e)
        {
        }

        protected void FormView1_ModeChanging(object sender, FormViewModeEventArgs e)
        {
            Load_DetailsView(EntityIDhide.Text.ToString());
        }

        protected void fv_DataBound(object sender, EventArgs e)
        { }

        public void UpdateFormView()
        {
            string tmp_loginname = ((TextBox)FormView1.FindControl("txtUserName")).Text.ToString().Trim();
            string tmp_UserCode = ((TextBox)FormView1.FindControl("txtUserCode")).Text.ToString().Trim();
            string tmp_UserID = ((TextBox)FormView1.FindControl("txtUserID")).Text.ToString().Trim();
            string tmp_CompanyName = ((TextBox)FormView1.FindControl("txtCompanyName")).Text.ToString().Trim();
            string tmp_CompanyPhone = ((TextBox)FormView1.FindControl("txtCompanyPhone")).Text.ToString().Trim();
            string tmp_Email = ((TextBox)FormView1.FindControl("txtEmail")).Text.ToString().Trim();
            string tmp_Country = ((DropDownList)FormView1.FindControl("DropDownListcountry")).Text.ToString().Trim();
            string tmp_Region = ((DropDownList)FormView1.FindControl("DropDownListregion")).Text.ToString().Trim();
            string tmp_City = ((TextBox)FormView1.FindControl("txtCity")).Text.ToString().Trim();
            string tmp_InvoiceName = ((TextBox)FormView1.FindControl("txtInvoiceName")).Text.ToString().Trim();
            string tmp_InvoiceAddress = ((TextBox)FormView1.FindControl("txtInvoiceAddress")).Text.ToString().Trim();
            string tmp_InvoicePhone = ((TextBox)FormView1.FindControl("txtInvoicePhone")).Text.ToString().Trim();
            string tmp_InvoiceTax = ((TextBox)FormView1.FindControl("txtInvoiceTax")).Text.ToString().Trim();
            
            try
            {
                string spToRun = "user_update";
                using (SqlConnection MyConnection = new SqlConnection(Global.LiveConnString))
                {
                    SqlCommand myCommand = new SqlCommand(spToRun, MyConnection);
                    myCommand.CommandText = spToRun;
                    myCommand.CommandType = CommandType.StoredProcedure;

                    SqlParameter myItemIDParm = myCommand.Parameters.Add("@p_users_code", SqlDbType.NVarChar);
                    myItemIDParm.Direction = ParameterDirection.Input;
                    myItemIDParm.Value = tmp_UserCode;

                    SqlParameter myUSeridParm = myCommand.Parameters.Add("@p_users_id", SqlDbType.Int);
                    myUSeridParm.Direction = ParameterDirection.Input;
                    myUSeridParm.Value =tmp_UserID;

                    SqlParameter myUSerNameParm = myCommand.Parameters.Add("@p_users_name", SqlDbType.NVarChar);
                    myUSerNameParm.Direction = ParameterDirection.Input;
                    myUSerNameParm.Value =tmp_loginname;

                    SqlParameter myEmailParm = myCommand.Parameters.Add("@p_email", SqlDbType.NVarChar);
                    myEmailParm.Direction = ParameterDirection.Input;
                    myEmailParm.Value = tmp_Email;

                    SqlParameter myCountryParm = myCommand.Parameters.Add("@p_country", SqlDbType.NVarChar);
                    myCountryParm.Direction = ParameterDirection.Input;
                    myCountryParm.Value = tmp_Country;

                    SqlParameter myRegionParm = myCommand.Parameters.Add("@p_region", SqlDbType.NVarChar);
                    myRegionParm.Direction = ParameterDirection.Input;
                    myRegionParm.Value = tmp_Region;

                    SqlParameter myCityParm = myCommand.Parameters.Add("@p_city", SqlDbType.NVarChar);
                    myCityParm.Direction = ParameterDirection.Input;
                    myCityParm.Value = tmp_City;

                    SqlParameter myCompanyNameParm = myCommand.Parameters.Add("@p_company_name", SqlDbType.NVarChar);
                    myCompanyNameParm.Direction = ParameterDirection.Input;
                    myCompanyNameParm.Value = tmp_CompanyName;

                    SqlParameter myCPhoneParm = myCommand.Parameters.Add("@p_company_phone", SqlDbType.NVarChar);
                    myCPhoneParm.Direction = ParameterDirection.Input;
                    myCPhoneParm.Value = tmp_CompanyPhone;

                    SqlParameter myPWDParm = myCommand.Parameters.Add("@p_invoice_name", SqlDbType.NVarChar);
                    myPWDParm.Direction = ParameterDirection.Input;
                    myPWDParm.Value =tmp_InvoiceName;

                    SqlParameter myGUIDParm = myCommand.Parameters.Add("@p_invoice_address", SqlDbType.NVarChar);
                    myGUIDParm.Direction = ParameterDirection.Input;
                    myGUIDParm.Value = tmp_InvoiceAddress;

                    SqlParameter myIPhoneParm = myCommand.Parameters.Add("@p_invoice_phone", SqlDbType.NVarChar);
                    myIPhoneParm.Direction = ParameterDirection.Input;
                    myIPhoneParm.Value =tmp_InvoicePhone;

                    SqlParameter myITaxParm = myCommand.Parameters.Add("@p_invoice_tax", SqlDbType.NVarChar);
                    myITaxParm.Direction = ParameterDirection.Input;
                    myITaxParm.Value = tmp_InvoiceTax;

                    SqlParameter myMBError = myCommand.Parameters.Add("@isvalid", SqlDbType.NVarChar, 100);
                    myMBError.Direction = ParameterDirection.Output;

                    SqlParameter returnValue = new SqlParameter("returnVal", SqlDbType.Int);
                    returnValue.Direction = ParameterDirection.ReturnValue;
                    myCommand.Parameters.Add(returnValue);

                    try
                    {
                        myCommand.Connection.Open();
                    }
                    catch (SqlException ex)
                    {
                        labelMessage.Text = "CONNECTION OPEN FAILURE:" + ex.ToString();
                        return;
                    }

                    try
                    {
                        myCommand.ExecuteNonQuery();
                    }
                    catch (SqlException ex)
                    {
                        labelMessage.Text = "EXECUTE NONQUERY FAILURE:" + ex.ToString();
                        return;
                    }

                    int tmpSPReturnValue = Convert.ToInt32(returnValue.Value);
                    if (tmpSPReturnValue == 0)
                    {
                        labelMessage.Text = myMBError.Value.ToString();
                    }
                    else
                    {
                        labelMessage.Text = myMBError.Value.ToString();
                        return;
                    }
                } 
            }
            catch (Exception ex)
            {
                labelMessage.Text = ex.Message;
            }
        }

        protected void BacktoPreviousPage(object sender, EventArgs e)
        {
            MultiView1.ActiveViewIndex = 0;
            labelMessage.Text = "";
        }
    }
}