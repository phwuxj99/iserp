/****************************
 * Date Created: Feb 09, 2012
 * Programmer: Stephen Wu 
 ***************************/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

namespace iserp
{
    public partial class PartnoNew : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();
            }
            string a = shared.HelperMethods.GetConnectionStringLive();
        }

        protected void LoadCategories()
        {
            using (App_Data.DataClassesERPDataContext db = new App_Data.DataClassesERPDataContext())
            {
                var categories = from c in db.categories
                                 where c.@operator == Global.UserEntityID.ToString()
                                 select new { tmpValue = c.id_num,tmpText = c.category_name};
                DropDownListcategory.DataSource = categories;
                DropDownListcategory.DataTextField = "tmpText";
                DropDownListcategory.DataValueField = "tmpValue";
                DropDownListcategory.DataBind();
            }
        }

        protected void LogButton_OnClick(object sender, EventArgs e)
        {

            Message.Text = "";

            try
            {
                using (SqlConnection myConnection = new SqlConnection(Global.LiveConnString))
                {

                    using (SqlCommand mycmd1 = new SqlCommand("add_partno_d", myConnection))
                    {
                        myConnection.Open();
                        mycmd1.CommandType = CommandType.StoredProcedure;

                        SqlParameter myparam = mycmd1.Parameters.Add("RETURN_VALUE", SqlDbType.Int);
                        myparam.Direction = ParameterDirection.ReturnValue;

                        myparam = mycmd1.Parameters.Add("@p_part_no", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = part_no.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_part_name", SqlDbType.NVarChar, 85);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = part_name.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_part_description", SqlDbType.NVarChar, 500);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = part_description.Value.Trim();

                        myparam = mycmd1.Parameters.Add("@p_unit", SqlDbType.NVarChar, 15);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = unit.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_category", SqlDbType.NVarChar, 65);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = DropDownListcategory.SelectedItem.Value.Trim();

                        myparam = mycmd1.Parameters.Add("@p_uprice", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = price1.Text.ToString().Trim();

                        myparam = mycmd1.Parameters.Add("@p_cprice", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = price2.Text.ToString().Trim(); 

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
                        myparam.Value = weight.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_usercode", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = Global.UserEntityID;

                        myparam = mycmd1.Parameters.Add("@p_notes", SqlDbType.NText);
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
            part_no.Focus();

        }
    }
}