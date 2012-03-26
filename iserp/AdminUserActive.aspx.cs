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
    public partial class AdminUserActive : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                GridviewBind();
        }

        protected void GridviewBind()
        {
            using (App_Data.DataClassesERPDataContext erpdb = new App_Data.DataClassesERPDataContext())
            {
                var UserData = from u in erpdb.aspnet_Users
                               join m in erpdb.aspnet_Memberships on u.UserId equals m.UserId
                               orderby u.UserName
                               select new
                               {
                                   user_id = u.UserId,
                                   user_code = u.UserName,
                                   email = m.Email,
                                   last_login_date = m.LastLoginDate,
                                   register_date = m.CreateDate,
                                   active_flag = u.MobileAlias
                               };
                GridView1.DataSource = UserData;
                GridView1.DataBind();
            }
        }


        public void UserActive(object sender, GridViewCommandEventArgs e)
        {

            if (e.CommandName == "UserActive")
            {
                using (App_Data.DataClassesERPDataContext erpdb = new App_Data.DataClassesERPDataContext())
                {
                    int index = Convert.ToInt32(e.CommandArgument);
                    string userstmp = GridView1.DataKeys[index].Value.ToString();
                    LblID.Text = userstmp;
                    var UserData = from u in erpdb.aspnet_Users
                                   join m in erpdb.aspnet_Memberships on u.UserId equals m.UserId
                                   where u.UserId.ToString() == userstmp
                                   select new
                                   {
                                       user_code = u.UserName,
                                       email = m.Email,
                                       last_login_date = m.LastLoginDate,
                                       register_date = m.CreateDate,
                                       active_flag = u.MobileAlias
                                   };

                    foreach (var ud in UserData)
                    {
                        txtLoginName.Text = ud.user_code;
                        txtEmail.Text = ud.email;
                    }
                }

                MultiView1.ActiveViewIndex = 1;
            }
        }

        protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridView1.PageIndex = e.NewPageIndex;
            GridviewBind();
        }


        protected void btnRegister_Click(object sender, EventArgs e)
        {

            string tmp_Guid = LblID.Text;// Guid.NewGuid().ToString();
            string tmp_loginname = txtLoginName.Text.Trim();
            string tmp_FullName = "Empty"; //txtFullName.Text.Trim();
            string tmp_CompanyName = txtCompanyName.Text.Trim();
            string tmp_CompanyPhone = txtCompanyPhone.Text;
            string tmp_password = "123456";
            string tmp_Email = txtEmail.Text.Trim();
            string tmp_Country = DropDownListcountry.SelectedItem.Value.Trim();
            string tmp_Region = DropDownListregion.SelectedItem.Value.Trim();
            string tmp_City = txtCity.Text.Trim();
            //string isvalid = "";

            if (tmp_FullName == "" || tmp_FullName.Length < 1)
            {
                tmp_FullName = "TMP";
            }

            if (tmp_CompanyName == "" || tmp_CompanyName.Length < 1)
            {
                tmp_CompanyName = "TMP";
            }

            if (tmp_CompanyPhone == "" || tmp_CompanyPhone.Length < 1)
            {
                tmp_CompanyPhone = "TMP";
            }

            if (tmp_Country == "" || tmp_Country.Length < 1)
            {
                tmp_Country = "TMP";
            }

            if (tmp_Region == "" || tmp_Region.Length < 1)
            {
                tmp_Region = "TMP";
            }

            if (tmp_City == "" || tmp_City.Length < 1)
            {
                tmp_City = "TMP";
            }

            string spToRun = "user_register";
            using (SqlConnection MyConnection = new SqlConnection(Global.LiveConnString))
            {
                SqlCommand myCommand = new SqlCommand(spToRun, MyConnection);
                myCommand.CommandText = spToRun;
                myCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter myItemIDParm = myCommand.Parameters.Add("@p_users_code", SqlDbType.NVarChar);
                myItemIDParm.Direction = ParameterDirection.Input;
                myItemIDParm.Value = tmp_loginname;

                SqlParameter myUSeridParm = myCommand.Parameters.Add("@p_users_id", SqlDbType.Int);
                myUSeridParm.Direction = ParameterDirection.Input;
                myUSeridParm.Value = txtUserID.Text;

                SqlParameter myUSerNameParm = myCommand.Parameters.Add("@p_users_name", SqlDbType.NVarChar);
                myUSerNameParm.Direction = ParameterDirection.Input;
                myUSerNameParm.Value = tmp_FullName;

                SqlParameter myEmailParm = myCommand.Parameters.Add("@p_email", SqlDbType.NVarChar);
                myEmailParm.Direction = ParameterDirection.Input;
                myEmailParm.Value = tmp_Email;

                SqlParameter myPWDParm = myCommand.Parameters.Add("@p_password", SqlDbType.NVarChar);
                myPWDParm.Direction = ParameterDirection.Input;
                myPWDParm.Value = tmp_password;

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

                //SqlParameter myGUIDParm = myCommand.Parameters.Add("@p_user_GUID", SqlDbType.NVarChar);
                //myGUIDParm.Direction = ParameterDirection.Input;
                //myGUIDParm.Value = tmp_Guid;

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
                    Message.Text = "CONNECTION OPEN FAILURE:" + ex.ToString();
                    return;
                }

                try
                {
                    myCommand.ExecuteNonQuery();
                }
                catch (SqlException ex)
                {
                    Message.Text = "EXECUTE NONQUERY FAILURE:" + ex.ToString();
                    return;
                }

                int tmpSPReturnValue = Convert.ToInt32(returnValue.Value);
                if (tmpSPReturnValue == 0)
                {
                    Message.Text = myMBError.Value.ToString();

                    ModifyStatus(tmp_Guid);
                }
                else
                {
                    Message.Text = myMBError.Value.ToString();
                    return;
                }
            }
        }

        private void ModifyStatus(string userid)
        {
            using (App_Data.DataClassesERPDataContext erpdb = new App_Data.DataClassesERPDataContext())
            {
                var UserData = from u in erpdb.aspnet_Users
                               where u.UserId.ToString() == userid
                               select u;

                foreach (var ud in UserData)
                {
                    ud.MobileAlias = "Active";
                }

                try
                {
                    erpdb.SubmitChanges();
                }
                catch (Exception e)
                {
                    Message.Text = e.Message;
                    // Provide for exceptions.
                }
            }
        }

        protected void BacktoPreviousPage(object sender, EventArgs e)
        {
            MultiView1.ActiveViewIndex = 0;
            Message.Text = "";
        }
    }
}