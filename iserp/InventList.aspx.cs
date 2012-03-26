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
using System.Web.Security;

namespace iserp
{
    public partial class InventList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Load_GridView();

            // Dim LoginUser As MembershipUser = Membership.GetUser(HttpContext.Current.User.Identity.Name)
            // MembershipUser tLoginUser = Membership.GetUser(HttpContext.Current.User.Identity.Name);
            // ErrorBox.Text = tLoginUser.ToString() ;
            // ErrorBox.Text = Page.User.Identity.Name;
            // forums.asp.net/t/1403132.aspx
        }

        protected void Load_GridView()
        {
            string tmpUserCode = Global.UserEntityID.ToString();
            string tmpsearchbox = txbSearchKeyword.Text.Trim().ToString() + "%";
            using (App_Data.DataClassesERPDataContext erpdb = new App_Data.DataClassesERPDataContext())
            {
                var allPartNo = from c in erpdb.warehouses
                                where SqlMethods.Like(c.part_no, tmpsearchbox) & c.@operator == tmpUserCode & c.qty > 0
                                orderby c.part_no
                                select c;
                GridView1.DataSource = allPartNo;
                GridView1.DataBind();
            }
        }

        protected void Search_Click(object sender, EventArgs e)
        {
            Load_GridView();
        }

        protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridView1.PageIndex = e.NewPageIndex;
            GridView1.DataBind();
        }
    }
}