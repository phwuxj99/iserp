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
    public partial class AdminUserMenu : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                get_dropdownlist_users();
        }

        protected void get_dropdownlist_users()
        {
            using (App_Data.DataClassesERPDataContext erpdb = new App_Data.DataClassesERPDataContext())
            {
                var users = from user in erpdb.users_infos
                            orderby user.users_name
                            select new { users_name = user.users_name, users_code = user.users_code };
                DropDownListUsers.DataSource = users;
                DropDownListUsers.DataTextField = "users_code";
                DropDownListUsers.DataValueField = "users_code";
                DropDownListUsers.DataBind();
            }
        }

        protected void btnButton1_click(object sender, EventArgs e)
        {
            Message.Text = "";
            string spToRun = "user_setmenu";
            using (SqlConnection myConnection = new SqlConnection(Global.LiveConnString))
            {
                SqlCommand myCommand = new SqlCommand(spToRun, myConnection);
                myCommand.CommandText = spToRun;
                myCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter myparam = myCommand.Parameters.Add("RETURN_VALUE", SqlDbType.Int);
                myparam.Direction = ParameterDirection.ReturnValue;

                 myparam = myCommand.Parameters.Add("@p_usercode", SqlDbType.NVarChar, 35);
                myparam.Direction = ParameterDirection.Input;
                myparam.Value = DropDownListUsers.SelectedItem.Text.Trim();

                myparam = myCommand.Parameters.Add("@isvalid", SqlDbType.NVarChar, 253);
                myparam.Direction = ParameterDirection.Output;


                try
                {
                    myCommand.Connection.Open();
                }
                catch (SqlException sqlex)
                {
                    Message.Text = "CONNECTION OPEN FAILURE";
                    return;
                }

                try
                {
                    using (SqlDataReader myreader = myCommand.ExecuteReader())
                    {

                        if (((int)(myCommand.Parameters["RETURN_VALUE"].Value)) == 0)
                        {
                            Message.Text = (string)(myCommand.Parameters["@isvalid"].Value);
                        }
                        else
                        {
                            Message.Text = (string)(myCommand.Parameters["@isvalid"].Value);
                            Message.Style["color"] = "red";
                        }
                    }
                }
                catch (SqlException sqlex)
                {
                    Message.Text = sqlex.Message.ToString();
                    return;
                }
            }
        }

        protected void btnButton2_click(object sender, EventArgs e)
        {
            Message.Text = "";
            string spToRun = "user_setmenuAll";
            using (SqlConnection myConnection = new SqlConnection(Global.LiveConnString))
            {
                SqlCommand myCommand = new SqlCommand(spToRun, myConnection);
                myCommand.CommandText = spToRun;
                myCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter myparam = myCommand.Parameters.Add("RETURN_VALUE", SqlDbType.Int);
                myparam.Direction = ParameterDirection.ReturnValue;
                
                myparam = myCommand.Parameters.Add("@p_usercode", SqlDbType.NVarChar, 35);
                myparam.Direction = ParameterDirection.Input;
                myparam.Value = DropDownListUsers.SelectedItem.Text.Trim();

                myparam = myCommand.Parameters.Add("@isvalid", SqlDbType.NVarChar, 253);
                myparam.Direction = ParameterDirection.Output;


                try
                {
                    myCommand.Connection.Open();
                }
                catch (SqlException sqlex)
                {
                    Message.Text = "CONNECTION OPEN FAILURE";
                    return;
                }

                try
                {
                    using (SqlDataReader myreader = myCommand.ExecuteReader())
                    {

                        if (((int)(myCommand.Parameters["RETURN_VALUE"].Value)) == 0)
                        {
                            Message.Text = (string)(myCommand.Parameters["@isvalid"].Value);
                        }
                        else
                        {
                            Message.Text = (string)(myCommand.Parameters["@isvalid"].Value);
                            Message.Style["color"] = "red";
                        }
                    }
                }
                catch (SqlException sqlex)
                {
                    Message.Text = sqlex.Message.ToString();
                    return;
                }
            }
        }

        protected void OnSelectedIndex_Changed(object sender, EventArgs e)
        {
            Message.Text = "";
            string spToRun = "user_getmenu";
            using (SqlConnection myConnection = new SqlConnection(Global.LiveConnString))
            {
                SqlCommand myCommand = new SqlCommand(spToRun, myConnection);
                myCommand.CommandText = spToRun;
                myCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter myparam = myCommand.Parameters.Add("@p_users_code", SqlDbType.NVarChar, 35);
                myparam.Direction = ParameterDirection.Input;
                myparam.Value = DropDownListUsers.SelectedItem.Text.Trim();

                DataSet objDataSet = new DataSet();

                try
                {
                    myCommand.Connection.Open();
                }
                catch (SqlException sqlex)
                {
                    Message.Text = "CONNECTION OPEN FAILURE";
                    return;
                }

                try
                {
                    SqlDataAdapter objDataAdapter = new SqlDataAdapter(myCommand);
                    objDataAdapter.Fill(objDataSet);
                    if (objDataSet.Tables[0].Rows.Count > 0)
                    {
                        grd.DataSource = objDataSet.Tables[0];
                        grd.DataBind();
                    }
                    else
                    {
                        grd.DataSource = null;
                        grd.DataBind();
                    }
                }
                catch (SqlException ex)
                {
                    Message.Text = "EXECUTE NONQUERY FAILURE";
                    return;
                }
            }
        }

        protected void OnDataBound(object sender, GridViewRowEventArgs e)
        {
            Message.Text = "";
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                GridView CHldGrd = (GridView)e.Row.FindControl("ChldGrid");

                string tmp_menuID = grd.DataKeys[e.Row.RowIndex].Value.ToString();

                string spToRun = "user_getsubmenu";
                using (SqlConnection myConnection = new SqlConnection(Global.LiveConnString))
                {
                    SqlCommand myCommand = new SqlCommand(spToRun, myConnection);
                    myCommand.CommandText = spToRun;
                    myCommand.CommandType = CommandType.StoredProcedure;

                    SqlParameter myparam = myCommand.Parameters.Add("@p_users_code", SqlDbType.NVarChar, 35);
                    myparam.Direction = ParameterDirection.Input;
                    myparam.Value = DropDownListUsers.SelectedItem.Text.Trim();

                    SqlParameter my2param = myCommand.Parameters.Add("@p_menuID", SqlDbType.NVarChar, 35);
                    my2param.Direction = ParameterDirection.Input;
                    my2param.Value = tmp_menuID;

                    DataSet objDataSet = new DataSet();

                    try
                    {
                        myCommand.Connection.Open();
                    }
                    catch (SqlException sqlex)
                    {
                        Message.Text = "CONNECTION OPEN FAILURE";
                        return;
                    }

                    try
                    {
                        SqlDataAdapter objDataAdapter = new SqlDataAdapter(myCommand);
                        objDataAdapter.Fill(objDataSet);
                        if (objDataSet.Tables[0].Rows.Count > 0)
                        {
                            CHldGrd.DataSource = objDataSet.Tables[0];
                            CHldGrd.DataBind();
                        }
                        else
                        {
                            grd.DataSource = null;
                            grd.DataBind();
                        }
                    }
                    catch (SqlException ex)
                    {
                        Message.Text = "EXECUTE NONQUERY FAILURE";
                        return;
                    }
                }
            }
        }


        protected void chkSelectAll_CheckedChanged2(object sender, EventArgs e)
        {
            int tStatus;
            int intDataKey = Convert.ToInt32(grd.DataKeys[((GridViewRow)((CheckBox)sender).Parent.Parent).RowIndex].Value);
            Message.Text = intDataKey.ToString();

            int test1 = ((GridViewRow)((CheckBox)sender).Parent.Parent).RowIndex;
            //Label1.Text = intDataKey.ToString();
            CheckBox chkAll = (CheckBox)grd.Rows[test1].FindControl("chkSelectAll");

            CheckBox chkSelect = (CheckBox)sender;
            GridViewRow row = (GridViewRow)chkSelect.NamingContainer;
            //Label1.Text += "   " + row.Cells[0].Text + "  " + test1.ToString();
            if (chkAll.Checked == true)
            {
                tStatus = 1;
                test(test1);
                chkAll.BackColor = System.Drawing.Color.Black;
            }
            else
            {
                tStatus = 0;
                unchecked_test(test1);
                chkAll.BackColor = System.Drawing.Color.White;
            }

            ParentSetMenu(intDataKey, tStatus);
        }

        private void ParentSetMenu(int ParentMenuID, int tmpStatus)
        {
            Message.Text = "";

            try
            {
                using (SqlConnection myConnection = new SqlConnection(Global.LiveConnString))
                {

                    using (SqlCommand mycmd1 = new SqlCommand("user_setmenuParent", myConnection))
                    {
                        myConnection.Open();
                        mycmd1.CommandType = CommandType.StoredProcedure;

                        SqlParameter myparam = mycmd1.Parameters.Add("RETURN_VALUE", SqlDbType.Int);
                        myparam.Direction = ParameterDirection.ReturnValue;

                        myparam = mycmd1.Parameters.Add("@p_usercode", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = DropDownListUsers.SelectedItem.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_ParentID", SqlDbType.Int);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = ParentMenuID;

                        myparam = mycmd1.Parameters.Add("@p_Status", SqlDbType.Int);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = tmpStatus;

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
        }

        protected void test(int aaa)
        {
            GridView subGrid = (GridView)grd.Rows[aaa].FindControl("ChldGrid");
            foreach (GridViewRow gvRow in subGrid.Rows)
            {
                CheckBox chkSel = (CheckBox)gvRow.FindControl("chk");
                chkSel.Checked = true;

                TextBox txtname = (TextBox)gvRow.FindControl("txtName");
                // TextBox txtlocation = (TextBox)gvRow.FindControl("txtLocation");
                txtname.ReadOnly = true;
                // txtlocation.ReadOnly = true;
                txtname.ForeColor = System.Drawing.Color.Black;
                // txtlocation.ForeColor = System.Drawing.Color.Black;
            }
        }

        protected void unchecked_test(int aaa)
        {
            GridView subGrid = (GridView)grd.Rows[aaa].FindControl("ChldGrid");
            foreach (GridViewRow gvRow in subGrid.Rows)
            {

                CheckBox chkSel = (CheckBox)gvRow.FindControl("chk");
                chkSel.Checked = false;
                TextBox txtname = (TextBox)gvRow.FindControl("txtName");
                // TextBox txtlocation = (TextBox)gvRow.FindControl("txtLocation");
                txtname.ReadOnly = true;
                // txtlocation.ReadOnly = true;
                txtname.ForeColor = System.Drawing.Color.Blue;
                // txtlocation.ForeColor = System.Drawing.Color.Blue;
            }
        }


        protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
        {
            //int datakeys = Convert.ToInt32(grd.DataKeys[row.RowIndex].Value);

            string[] arInfo = new string[4];

            CheckBox chkSelect = (CheckBox)sender;
            GridViewRow row = (GridViewRow)chkSelect.NamingContainer;
            string a1 = row.Cells[1].NamingContainer.UniqueID.ToString();
            char[] splitter = { '$' };
            arInfo = a1.Split(splitter);
            string b1 = arInfo[0];
            string b2 = arInfo[1];
            string b3 = arInfo[2];

            //Label1.Text = row.Cells[1].NamingContainer.ClientID.ToString();
            int test = ((GridViewRow)((CheckBox)sender).Parent.Parent).RowIndex;
            //Label1.Text += "   " + test.ToString() + " " + a1;
            string test1 = row.Cells[1].Text.ToString();
            //Label1.Text += "   " + test1.ToString();
            for (int i = 0; i < grd.Rows.Count; i++)
            {
                string test3 = "No";
                GridView subGrid = (GridView)grd.Rows[i].FindControl("ChldGrid");
                foreach (GridViewRow gvRow in subGrid.Rows)
                {
                    string a2 = gvRow.Cells[1].NamingContainer.UniqueID.ToString();
                    arInfo = a2.Split(splitter);
                    string c1 = arInfo[0];
                    string c2 = arInfo[1];
                    string c3 = arInfo[2];

                    if (b1 == c1 && b2 == c2 && b3 == c3)
                    {
                        test3 = "yes";
                        //Label1.Text += "  " + i.ToString() + "   " + a2 + " " + test3.ToString();
                    }
                }
            }
        }


        protected void chkSelect_CheckedChanged(object sender, EventArgs e)
        {
            int tStatus;
            string[] arInfo = new string[4];

            CheckBox chkSelect = (CheckBox)sender;
            GridViewRow row = (GridViewRow)chkSelect.NamingContainer;

            string a1 = row.Cells[1].NamingContainer.UniqueID.ToString();
            char[] splitter = { '$' };
            arInfo = a1.Split(splitter);
            string b1 = arInfo[0];
            string b2 = arInfo[1];
            string b3 = arInfo[2];

            CheckBox chkTest = (CheckBox)sender;
            GridViewRow grdRow = (GridViewRow)chkTest.NamingContainer;


            //GridView myGrid = (GridView)chkTest.NamingContainer.Parent.Parent; // the gridview
            //Message.Text = grdRow.RowIndex.ToString(); //myGrid.DataKeys[myRow.RowIndex].Value.ToString(); // value of the datakey 


            //Message.Text = (TextBox)grdRow.
            TextBox txtname = (TextBox)grdRow.FindControl("txtName");
            TextBox txtMenuID = (TextBox)grdRow.FindControl("txtMenuID");
            if (chkTest.Checked)
            {
                tStatus = 1;
                txtname.ReadOnly = false;
                //txtlocation.ReadOnly = false;
                txtname.ForeColor = System.Drawing.Color.Black;
                //txtlocation.ForeColor = System.Drawing.Color.Black;
            }
            else
            {
                tStatus = 0;
                txtname.ReadOnly = true;
                //txtlocation.ReadOnly = true;
                txtname.ForeColor = System.Drawing.Color.Blue;
                //txtlocation.ForeColor = System.Drawing.Color.Blue;
            }

            for (int i = 0; i < grd.Rows.Count; i++)
            {
                int rowcount = 0, tmprowcount = 0, tmprowcount2 = 0;
                string test3 = "No";
                string tmpflag1 = "N", tmpflag2 = "N";
                GridView subGrid = (GridView)grd.Rows[i].FindControl("ChldGrid");
                foreach (GridViewRow gvRow in subGrid.Rows)
                {
                    string a2 = gvRow.Cells[1].NamingContainer.UniqueID.ToString();
                    arInfo = a2.Split(splitter);
                    string c1 = arInfo[0];
                    string c2 = arInfo[1];
                    string c3 = arInfo[2];
                    rowcount += 1;
                    if (b1 == c1 && b2 == c2 && b3 == c3)
                    {
                        CheckBox chkSelectaa = (CheckBox)gvRow.FindControl("chk");
                        if (chkSelectaa.Checked == false)
                        {
                            tmpflag1 = "Y";
                            tmprowcount += 1;
                        }
                        else
                        {
                            tmprowcount2 += 1;
                            tmpflag2 = "NA";
                        }
                        //Label1.Text += "  " + i.ToString() + "   " + a2 + " " + test3.ToString();
                    }
                }
                if (tmpflag1 == "Y" && rowcount == tmprowcount)
                {
                    CheckBox chkAll = (CheckBox)grd.Rows[i].FindControl("chkSelectAll");
                    chkAll.Checked = false;
                    chkAll.BackColor = System.Drawing.Color.White;
                }
                else if (tmpflag2 == "NA" && rowcount == tmprowcount2)
                {
                    CheckBox chkAll = (CheckBox)grd.Rows[i].FindControl("chkSelectAll");
                    chkAll.Checked = true;
                    chkAll.BackColor = System.Drawing.Color.Black;
                }
                else if (tmpflag1 == "Y" && tmpflag2 == "NA")
                {
                    CheckBox chkAll = (CheckBox)grd.Rows[i].FindControl("chkSelectAll");
                    chkAll.BackColor = System.Drawing.Color.Yellow;
                    chkAll.Checked = true;
                }
            }

            SingleSetMenu(Convert.ToInt32(txtMenuID.Text.ToString()), tStatus);
        }


        private void SingleSetMenu(int ParentMenuID, int tmpStatus)
        {
            Message.Text = "";

            try
            {
                using (SqlConnection myConnection = new SqlConnection(Global.LiveConnString))
                {

                    using (SqlCommand mycmd1 = new SqlCommand("user_setmenuSingle", myConnection))
                    {
                        myConnection.Open();
                        mycmd1.CommandType = CommandType.StoredProcedure;

                        SqlParameter myparam = mycmd1.Parameters.Add("RETURN_VALUE", SqlDbType.Int);
                        myparam.Direction = ParameterDirection.ReturnValue;

                        myparam = mycmd1.Parameters.Add("@p_menuID", SqlDbType.Int);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = ParentMenuID;

                        myparam = mycmd1.Parameters.Add("@p_usercode", SqlDbType.NVarChar, 35);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = DropDownListUsers.SelectedItem.Text.Trim();

                        myparam = mycmd1.Parameters.Add("@p_Status", SqlDbType.Int);
                        myparam.Direction = ParameterDirection.Input;
                        myparam.Value = tmpStatus;

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
        }
    }
}
