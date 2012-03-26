using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Web.Security;

namespace iserp
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            MembershipUser tLoginUser = Membership.GetUser(HttpContext.Current.User.Identity.Name);

            if (tLoginUser != null)
            {
                Global.UserCode = tLoginUser.UserName;
                GetUserMenu();
                if (Page.User.Identity.IsAuthenticated == true)
                {
                    NavigationMenu.Enabled = true;
                }
                else
                {
                    //Response.Redirect("login.aspx");
                    //Global.UserCode = "test";
                    NavigationMenu.Enabled = false;
                }
            }
        }

        private void GetUserMenu()
        {
            xmlDataSource.Data = null;
            using (App_Data.DataClassesERPDataContext erpdb = new App_Data.DataClassesERPDataContext())
            {
                var allClient = from c in erpdb.users_infos
                                where c.users_code == Global.UserCode
                                select c;
                foreach (var ac in allClient)
                {
                    Global.UserEntityID = ac.Entity_id.Value;
                }
            }

            // MembershipUser tLoginUser = Membership.GetUser(HttpContext.Current.User.Identity.Name);
            //if (Page.User.Identity.IsAuthenticated == true)
            //{
            //string userEntityID = "500";
            DataSet ds = new DataSet();
            //string connStr = "server=localhost;Trusted_Connection=true;database=MenuDb";
            string connStr = ConfigurationManager.ConnectionStrings["erpdbConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "Select menu_id as 'MenuID',menu_name as 'Text',menu_description as 'Description',url as'Url',partent_id as 'ParentID' from user_menu where users_entity = " + Global.UserEntityID;
                //string sql = "Select MenuID, Text, Url,Description, ParentID from Menu";
                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                da.Fill(ds);
                da.Dispose();
            }
            ds.DataSetName = "Menus";
            ds.Tables[0].TableName = "Menu";
            DataRelation relation = new DataRelation("ParentChild",
                    ds.Tables["Menu"].Columns["MenuID"],
                    ds.Tables["Menu"].Columns["ParentID"],
                    true);

            relation.Nested = true;
            ds.Relations.Add(relation);

            xmlDataSource.Data = ds.GetXml();
        }
    }
}
