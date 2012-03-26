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
    public partial class AdminUserProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            { LoadDetails(); }
        }

        protected void LoadDetails()
        {
            using (App_Data.DataClassesERPDataContext erpdb = new App_Data.DataClassesERPDataContext())
            {
                string userstmp = Global.UserCode.ToString();
                LblID.Text = userstmp;
                var UserData = from u in erpdb.users_infos
                               where u.users_code == userstmp
                               select u;

                foreach (var ud in UserData)
                {
                    txtLoginName.Text = ud.users_code;
                    txtEmail.Text = ud.email;
                    txtCompanyName.Text = ud.company_name;
                    txtCompanyPhone.Text = ud.company_phone;
                    txtCity.Text = ud.city;
                    txtUserID.Text = ud.user_id.ToString();
                }
            }
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
                }
                else
                {
                    Message.Text = myMBError.Value.ToString();
                    return;
                }
            }
        }

    }
}