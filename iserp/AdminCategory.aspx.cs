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
    public partial class AdminCategory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //using (App_Data.DataClassesERPDataContext erpdb = new App_Data.DataClassesERPDataContext())
            //{
            //    var allClient = from c in erpdb.categories
            //                    select c;

                
            //   ListView1.DataSource = allClient;
            //   ListView1.DataBind();
            //}

            //DynamicDataManager1.RegisterControl(ListView1);
            //ListView1.EnableDynamicData(typeof(iserp.App_Data.DataClassesERPDataContext));
        }

        protected void InstructorsGridView_SelectedIndexChanged(object sender, EventArgs e)
        {
        }

        protected void InstructorsGridView_RowUpdating(object sender, GridViewUpdateEventArgs e)
        { }

    }
}