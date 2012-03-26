using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace iserp
{
    public partial class ClientPOSearch : System.Web.UI.Page
    {
        decimal grdTotal = 0, grdTotalt = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                get_DropDownListClient();
            }
        }

        private void get_DropDownListClient()
        {
            string tmp_country = DropDownListcountry.SelectedItem.Value.Trim();
            string tmp_region = DropDownListregion.SelectedItem.Value.Trim();

            if (tmp_region == null || tmp_region.Length == 0)
            { tmp_region = null; }
            DropDownListClient.DataSource = null;
            using (App_Data.DataClassesERPDataContext erpdb = new App_Data.DataClassesERPDataContext())
            {

                var ddregion = from rg in erpdb.erpclients
                               where rg.countryID.ToString() == tmp_country && rg.locationID.ToString() == tmp_region && rg.@operator == Global.UserEntityID.ToString()
                               orderby rg.cname
                               select new { rg.cname, rg.cname_code };
                if (ddregion != null)
                {
                    DropDownListClient.DataSource = ddregion;
                    DropDownListClient.DataTextField = "cname";
                    DropDownListClient.DataValueField = "cname_code";
                    DropDownListClient.DataBind();
                }
                else
                {
                    DropDownListClient.DataSource = null;
                    DropDownListClient.DataBind();
                }
            }
        }

        protected void ClientChangeRegion(object sender, EventArgs e)
        {
            get_DropDownListClient();
        }

        protected void GetInvoiceDetails(object sender, EventArgs e)
        {
            BindData();
        }


        protected void BindData()
        {
            string tmpUserCode = Global.UserEntityID.ToString();
            using (App_Data.DataClassesERPDataContext db = new App_Data.DataClassesERPDataContext())
            {
                var whreceipt = from whc in db.invoices
                                where whc.@operator == tmpUserCode & whc.cname_code == DropDownListClient.SelectedValue.Trim().ToString()
                                group whc by whc.invoiceno into Group
                                select new { Group.Key, podate = Group.Max(whc => whc.invoicedate) };
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
                Invoice_no.Text = EntitynumberStr;
                // int EntitynumberInt = Convert.ToInt32(EntitynumberStr);

                Load_DetailsView(EntitynumberStr);
                MultiView1.ActiveViewIndex = 1;
            }
        }

        protected void Load_DetailsView(string EntitynumberStr)
        {
            string tmpCnameCode;
            string tmpUserCode = Global.UserEntityID.ToString();
            using (App_Data.DataClassesERPDataContext db = new App_Data.DataClassesERPDataContext())
            {
                var whreceipt = from whc in db.invoices
                                where whc.invoiceno.ToString() == EntitynumberStr && whc.@operator == tmpUserCode
                                select whc;
                int test = whreceipt.Count();
                if (test > 0)
                {
                    gvSample.DataSource = whreceipt;
                    gvSample.DataBind();
                }
                else
                {
                    gvSample.DataSource = null;
                    gvSample.DataBind();
                }

                foreach (var tdate in whreceipt)
                {
                    Invoice_date.Text = tdate.invoicedate.ToString();
                    tmpCnameCode = tdate.cname_code;
                    getCnameInfo(tmpCnameCode);
                }

            }
        }

        protected void getCnameInfo(string tCname)
        {
            using (App_Data.DataClassesERPDataContext db = new App_Data.DataClassesERPDataContext())
            {
                var whreceipt = (from whc in db.erpclients
                                 where whc.cname_code == tCname && whc.@operator == Global.UserEntityID.ToString()
                                 select whc).Single();
                LblCustomerName.Text = whreceipt.cname;
                LblCustomerAddress.Text = whreceipt.address + " " + whreceipt.city;
            }
        }

        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                decimal rowTotal = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "paidprice"));
                grdTotal = grdTotal + rowTotal;

                //tax
                decimal rowTotalt = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "tax"));
                grdTotalt = grdTotalt + rowTotalt;
            }

            if (e.Row.RowType == DataControlRowType.Footer)
            {
                Label lbl = (Label)e.Row.FindControl("lblTotal");
                lbl.Text = grdTotal.ToString("c");

                Label lblt = (Label)e.Row.FindControl("lblTotalT");
                lblt.Text = grdTotalt.ToString("c");

                Label lbltAll = (Label)e.Row.FindControl("lblTotalAll");
                lbltAll.Text = (grdTotal + grdTotalt).ToString("c");
            }


            if (e.Row.RowType == DataControlRowType.Footer)
            {
                int tmpCount = gvSample.Columns.Count;
                for (int i = 0; i < tmpCount - 3; i++)
                {
                    e.Row.Cells.RemoveAt(0);
                }

                e.Row.Cells[0].ColumnSpan = tmpCount - 2;
                e.Row.Cells[1].HorizontalAlign = HorizontalAlign.Center;
            }
        }


    }
}