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
    public partial class ClientSearch : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Load_GridView();
        }


        protected void Load_GridView()
        {
            string tmpUserCode = Global.UserEntityID.ToString();
            string tmpsearchbox = txbSearchKeyword.Text.Trim().ToString() + "%";
            using (App_Data.DataClassesERPDataContext erpdb = new App_Data.DataClassesERPDataContext())
            {
                var allClient = from c in erpdb.erpclients
                                where SqlMethods.Like(c.cname, tmpsearchbox) & c.@operator == tmpUserCode
                                orderby c.cname
                                select c;
                
                GridView1.DataSource = allClient;
                GridView1.DataBind();
            }
        }

        protected void BacktoPreviousPage(object sender, EventArgs e)
        {
            MultiView1.ActiveViewIndex = 0;
            ErrorBox.Text = "";
        }

        public void LoadDetails(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Details")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                string EntitynumberStr = GridView1.DataKeys[index].Value.ToString();
                EntityIDhide.Text = EntitynumberStr;

                // int EntitynumberInt = Convert.ToInt32(EntitynumberStr);

                Load_DetailsView(EntitynumberStr);

                MultiView1.ActiveViewIndex = 1;
            }
        }

        protected void Load_DetailsView(string TransFeeID)
        {
            using (App_Data.DataClassesERPDataContext erpdb = new App_Data.DataClassesERPDataContext())
            {
                var allPartNo = from c in erpdb.erpclients
                                where c.cname_code == TransFeeID
                                select c;
                FormView1.DataSource = allPartNo;
                FormView1.DataBind();
            }
        }


        protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridView1.PageIndex = e.NewPageIndex;
            GridView1.DataBind();
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

        public void UpdateFormView()
        {           
        }

        protected void Search_Click(object sender, EventArgs e)
        {
            Load_GridView();
        }
    }
}