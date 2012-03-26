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
    public partial class PartnoSearch : System.Web.UI.Page
    {
        public string Listcountries;

        protected void Page_Load(object sender, EventArgs e)
        {
            Load_GridView();
            // Listcountries = countryName();
        }

        protected void Load_GridView()
        {

            string tmpUserCode = Global.UserEntityID.ToString();
            string tmpPartNO = txbSearchKeyword.Text.Trim().ToString();
            string tmpsearchbox = "%" +shared.HelperMethods.GetPartNo(tmpPartNO) + "%";
            using (App_Data.DataClassesERPDataContext erpdb = new App_Data.DataClassesERPDataContext())
            {
                var allPartNo = from c in erpdb.partnos
                                where SqlMethods.Like(c.part_no, tmpsearchbox) & c.@operator == tmpUserCode
                                //where c.part_no.StartsWith(tmpsearchbox) & c.@operator == tmpUserCode
                                orderby c.part_no
                                select c;
                GridView1.DataSource = allPartNo;
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
                var allPartNo = from c in erpdb.partnos
                                where c.part_no == TransFeeID & c.@operator == Global.UserEntityID.ToString()
                                select c;
                FormView1.DataSource = allPartNo;
                FormView1.DataBind();

                foreach (var tmpC in allPartNo)
                {
                    int tidnum = Convert.ToInt32(tmpC.category);
                    var allCategories = from cc in erpdb.categories
                                        where cc.id_num == tidnum
                                        select cc;
                    Label lblcategory = FormView1.FindControl("lblCategory") as Label;
                    if (lblcategory != null)
                    {
                        foreach (var cc in allCategories)
                        {
                            lblcategory.Text = cc.category_name;
                        }
                    }
                }
            }
        }

        protected void fv_DataBound(object sender, EventArgs e)
        {
            if (FormView1.CurrentMode == FormViewMode.Edit)
            {
                DropDownList ddl1 = FormView1.FindControl("ddlCategory") as DropDownList;

                if (ddl1 != null)
                {
                    LoadCategories(ddl1);

                    ddl1.SelectedIndex = ddl1.Items.IndexOf(ddl1.Items.FindByValue(DataBinder.Eval(FormView1.DataItem, "category").ToString()));

                }

            }

        }

        protected void LoadCategories(DropDownList ddlCategory)
        {
            using (App_Data.DataClassesERPDataContext db = new App_Data.DataClassesERPDataContext())
            {
                var categories = from c in db.categories
                                 where c.@operator == Global.UserEntityID.ToString()
                                 select new { tmpValue = c.id_num, tmpText = c.category_name };
                ddlCategory.DataSource = categories;
                ddlCategory.DataTextField = "tmpText";
                ddlCategory.DataValueField = "tmpValue";
                ddlCategory.DataBind();
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
            decimal tmpweight;

            string tmpPartno = ((TextBox)FormView1.FindControl("part_no")).Text.ToString().Trim();
            string tmpPartname = ((TextBox)FormView1.FindControl("part_name")).Text.ToString().Trim();
            string tmpdescription = ((TextBox)FormView1.FindControl("part_description")).Text.ToString().Trim();
            string tmpunit = ((TextBox)FormView1.FindControl("unit")).Text.ToString().Trim();
            //string tmpcategory = ((TextBox)FormView1.FindControl("category")).Text.ToString().Trim();
            string tmpcategory = ((DropDownList)FormView1.FindControl("ddlCategory")).Text.ToString().Trim();
            string tmpprice = ((TextBox)FormView1.FindControl("price1")).Text.ToString().Trim();
            string tmpprice2 = ((TextBox)FormView1.FindControl("price2")).Text.ToString().Trim();

            string tweight = ((TextBox)FormView1.FindControl("weight")).Text.ToString().Trim();
            if (tweight == null || tweight == "")
            {
                tmpweight = 0;
            }
            else
            {
                tmpweight = Convert.ToDecimal(tweight);
            }

            string tmpnotes = ((TextBox)FormView1.FindControl("notes")).Text.ToString().Trim();



            ErrorBox.Text = "";

            try
            {
                using (SqlConnection myConnection = new SqlConnection(Global.LiveConnString))
                {

                    using (SqlCommand mycmd1 = new SqlCommand("update_partno_d", myConnection))
                    {
                        myConnection.Open();
                        mycmd1.CommandType = CommandType.StoredProcedure;

                        SqlParameter myparam = mycmd1.Parameters.Add("RETURN_VALUE", SqlDbType.Int);
                        myparam.Direction = ParameterDirection.ReturnValue;

                        myparam = mycmd1.Parameters.Add("@p_Partno", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = tmpPartno;

                        myparam = mycmd1.Parameters.Add("@p_part_name", SqlDbType.NVarChar, 85);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = tmpPartname;

                        myparam = mycmd1.Parameters.Add("@p_part_description", SqlDbType.NVarChar, 500);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = tmpdescription;

                        myparam = mycmd1.Parameters.Add("@p_unit", SqlDbType.NVarChar, 15);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = tmpunit;

                        myparam = mycmd1.Parameters.Add("@p_category", SqlDbType.NVarChar, 65);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = tmpcategory;

                        myparam = mycmd1.Parameters.Add("@p_uprice", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = tmpprice;

                        myparam = mycmd1.Parameters.Add("@p_cprice", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = tmpprice2;

                        myparam = mycmd1.Parameters.Add("@p_brand", SqlDbType.NVarChar, 65);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = "";//ddlBrand.SelectedItem.Value.Trim();

                        myparam = mycmd1.Parameters.Add("@p_series", SqlDbType.NVarChar, 65);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = "";// ddlSeries.SelectedItem.Value.Trim();

                        myparam = mycmd1.Parameters.Add("@p_model", SqlDbType.NVarChar, 65);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = "";//ddlModel.SelectedItem.Value.Trim();

                        myparam = mycmd1.Parameters.Add("@p_outputvalue", SqlDbType.NVarChar, 65);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = "";//outputvalue.Value.ToString().Trim();

                        myparam = mycmd1.Parameters.Add("@p_compatible", SqlDbType.NVarChar, 65);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = "";//compatible.Value.ToString().Trim();

                        myparam = mycmd1.Parameters.Add("@p_dimension", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = "1*1*1"; //dimension.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_weight", SqlDbType.NVarChar, 25);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = tmpweight;

                        myparam = mycmd1.Parameters.Add("@p_usercode", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = Global.UserEntityID;

                        myparam = mycmd1.Parameters.Add("@p_notes", SqlDbType.NText);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = tmpnotes;

                        myparam = mycmd1.Parameters.Add("@isvalid", SqlDbType.NVarChar, 253);
                        myparam.Direction = ParameterDirection.Output;


                        using (SqlDataReader myreader = mycmd1.ExecuteReader())
                        {

                            if (((int)(mycmd1.Parameters["RETURN_VALUE"].Value)) == 0)
                            {
                                ErrorBox.Text = (string)(mycmd1.Parameters["@isvalid"].Value);
                            }
                            else
                            {
                                ErrorBox.Text = (string)(mycmd1.Parameters["@isvalid"].Value);
                                ErrorBox.Style["color"] = "red";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ErrorBox.Text = ex.Message;
            }
            //LING TO SQL UPDATE
            //using (App_Data.DataClassesERPDataContext db = new App_Data.DataClassesERPDataContext())
            //{

            //    // Query the database for the row to be updated.
            //    var query =
            //        (from ord in db.partnos
            //        where ord.part_no == tmpPartno
            //        select ord).Single();

            //    // Execute the query, and change the column values
            //    // you want to change.
            //    //foreach (App_Data.partno ord in query)
            //    //{
            //    query.part_no = tmpPartno;
            //    query.part_name = tmpPartname;
            //    query.part_description = tmpdescription;
            //    query.unit = tmpunit;
            //    query.category = tmpcategory;
            //    query.dimension = tmpprice;
            //    query.weight = tmpweight;
            //    query.notes = tmpnotes;
            //    //}


            //    // Submit the changes to the database.
            //    try
            //    {
            //        db.SubmitChanges();
            //        ErrorBox.Text = "Updated Successfully!";
            //    }
            //    catch (Exception e)
            //    {
            //        ErrorBox.Text = e.Message.ToString();
            //    }
            //}
        }

        private string countryName()
        {
            StringBuilder sb = new StringBuilder();
            using (App_Data.DataClassesERPDataContext db = new App_Data.DataClassesERPDataContext())
            {
                var query =
                   from ord in db.partnos
                   //where ord.part_no == tmpPartno
                   select ord;

                // Execute the query, and change the column values
                // you want to change.
                foreach (App_Data.partno ord in query)
                {
                    sb.Append(Convert.ToString(ord.part_no.Trim() + "|"));
                }

                return Convert.ToString(sb);
            }
        }

        protected void Search_Click(object sender, EventArgs e)
        {
            Load_GridView();
            //litStatus.Text = "Search conducted for keyword: " + txbSearchKeyword.Text;
        }

    }
}