<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    EnableEventValidation="false" CodeBehind="AdminUsersList.aspx.cs" Inherits="iserp.AdminUsersList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <p align="center" class="green">
        <font color="#0000ff" size="4">User List & Edit&nbsp; </font>
    </p>
    <br />
    <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">
        <asp:View ID="View1" runat="server">
            <asp:GridView ID="GridView1" HorizontalAlign="Center" runat="server" AutoGenerateColumns="False"
                AllowPaging="True" PageSize="15" OnPageIndexChanging="GridView1_PageIndexChanging"
                Width="85%" DataKeyNames="users_code" CssClass="mGrid" EmptyDataText="No Data Currently"
                OnRowCommand="UserProfile" AlternatingRowStyle-CssClass="altRow">
                <Columns>
                    <asp:BoundField DataField="users_name" HeaderText="User Name" />
                    <asp:BoundField DataField="users_code" HeaderText="User Code" />
                    <asp:BoundField DataField="Entity_id" HeaderText="Entity ID" />
                    <asp:ButtonField ButtonType="Link" CommandName="UserProfile" HeaderText="" Text="Details" />
                </Columns>
            </asp:GridView>
            <br />
        </asp:View>
        <asp:View ID="View2" runat="server">
            <asp:Label ID="EntityIDhide" runat="server" Visible="false" Text="" Font-Bold="true"></asp:Label>
            <asp:FormView ID="FormView1" DataKeyNames="users_code" runat="server" OnItemUpdating="FormView1_ItemUpdating"
                OnModeChanging="FormView1_ModeChanging" CssClass="FormViewStyle FormViewWidth"
                OnDataBound="fv_DataBound" HorizontalAlign="Center" OnItemInserting="FormView1_Inserting"
                EmptyDataText="No Data Currently" OnModeChanged="FormView1_ModeChanged" OnItemCommand="FormView1_ItemCommand">
                <ItemTemplate>
                    <div class="DivTable">
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="LblID" runat="server" CssClass="Regtxt" Text="ID" Visible="False"></asp:Label>
                                &nbsp;<asp:Label ID="lblLoginName" runat="server" CssClass="Regtxt" Text="Name"></asp:Label>
                                &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" /></div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="txtLoginName" Text='<%# Bind("users_name") %>' runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="Label2" runat="server" CssClass="Regtxt" Text="User Code"> </asp:Label>
                                &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" />
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="txtUserCode" runat="server" Text='<%# Bind("users_code") %>' Style="margin-left: 0px"
                                    Width="225px"></asp:Label></div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="lblFullName" runat="server" CssClass="Regtxt" Text="User ID"> </asp:Label>
                                &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" />
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="txtUserID" runat="server" Text='<%# Bind("Entity_id") %>' Style="margin-left: 0px"
                                    Width="225px"></asp:Label></div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="lblEmail" runat="server" CssClass="Regtxt" Text="Email"> </asp:Label>
                                &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" /></div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="txtEmail" runat="server" Text='<%# Bind("email") %>' Width="225px"></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="lblCountry" runat="server" CssClass="Regtxt" Text="Country & Region"> </asp:Label>
                                &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" />
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:DropDownList ID="DropDownListcountry" runat="server" Width="146px" Height="19px">
                                </asp:DropDownList>
                                <ajaxToolkit:CascadingDropDown ID="CascadingDropDown1" runat="server" TargetControlID="DropDownListcountry"
                                    Category="country" PromptText="Please select a country" LoadingText="[Loading Country...]"
                                    SelectedValue='<%# Bind("country") %>' ServicePath="~/services/regionService.asmx"
                                    ServiceMethod="Getcountry" />
                                &nbsp; -- &nbsp;
                                <asp:DropDownList ID="DropDownListregion" runat="server" Width="173px" Height="21px">
                                </asp:DropDownList>
                                <ajaxToolkit:CascadingDropDown ID="CascadingDropDown2" runat="server" TargetControlID="DropDownListregion"
                                    Category="region" PromptText="Please select a region" LoadingText="[Loading Region...]"
                                    SelectedValue='<%# Bind("region") %>' ServicePath="~/services/regionService.asmx"
                                    ServiceMethod="Getregion" ParentControlID="DropDownListcountry" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="DropDownListregion">* </asp:RequiredFieldValidator>
                                <ajaxToolkit:ValidatorCalloutExtender ID="ValidatorCalloutExtender6" runat="server"
                                    HighlightCssClass="ErrorStyle" TargetControlID="RequiredFieldValidator5">
                                </ajaxToolkit:ValidatorCalloutExtender>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                &nbsp;&nbsp;
                                <asp:Label ID="lblCity" runat="server" CssClass="Regtxt" Text="City"></asp:Label>
                                &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" />
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="txtCity" runat="server" Text='<%# Bind("city") %>' Width="225px"></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                &nbsp;&nbsp;
                                <asp:Label ID="lblCompanyName" runat="server" CssClass="Regtxt" Text="CompanyName"></asp:Label>
                                &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" />
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="txtCompanyName" runat="server" Text='<%# Bind("company_name") %>'
                                    Width="225px"></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                &nbsp;<asp:Label ID="lblPhone" runat="server" CssClass="Regtxt" Text="Phone"></asp:Label>
                                &nbsp;<img height="25" src="image/01_telephone_inv_thumb.gif" width="25" alt="" /></div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="txtCompanyPhone" runat="server" Text='<%# Bind("company_phone") %>'
                                    Width="225px"></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                &nbsp;<asp:Label ID="Label3" runat="server" CssClass="Regtxt" Text="Invoice Name"></asp:Label>
                                &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" />
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="Label4" runat="server" Text='<%# Bind("invoice_name") %>' Width="225px"></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                &nbsp;<asp:Label ID="Label5" runat="server" CssClass="Regtxt" Text="Invoice Address"></asp:Label>
                                &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" />
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="Label6" runat="server" Text='<%# Bind("invoice_address") %>' Width="225px"></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                &nbsp;<asp:Label ID="Label9" runat="server" CssClass="Regtxt" Text="Invoice Phone"></asp:Label>
                                &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" />
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="Label10" runat="server" Text='<%# Bind("invoice_phone") %>' Width="225px"></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                &nbsp;<asp:Label ID="Label7" runat="server" CssClass="Regtxt" Text="Invoice Tax"></asp:Label>
                                &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" />
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="Label8" runat="server" Text='<%# Bind("invoice_tax") %>' Width="225px"></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="Label1" runat="server" CssClass="Regtxt" Text=""></asp:Label>
                                &nbsp;
                                <img height="25" src="image/51_rightarrow_inv_thumb.gif" alt="" width="25" />
                            </div>
                            <div class="DivTable2secondcol">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:Button ID="lbEdit" Text="Edit" CommandName="Edit" runat="server" />
                                <%--<asp:LinkButton ID="LbNew" Text="New" CommandName="New" runat="server" />--%>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
                <EditItemTemplate>
                    <div class="DivTable">
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="LblID" runat="server" CssClass="Regtxt" Text="ID" Visible="False"></asp:Label>
                                &nbsp;<asp:Label ID="lblLoginName" runat="server" CssClass="Regtxt" Text="Name"></asp:Label>
                                &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" /></div>
                            <div class="DivTable2secondcol">
                                <asp:TextBox ID="txtUserName" Text='<%# Bind("users_name") %>' runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="Label2" runat="server" CssClass="Regtxt" Text="User Code"> </asp:Label>
                                &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" />
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:TextBox ID="txtUserCode" runat="server" Text='<%# Bind("users_code") %>' Style="margin-left: 0px"
                                    Width="225px" Enabled="False"></asp:TextBox>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="lblFullName" runat="server" CssClass="Regtxt" Text="User ID"> </asp:Label>
                                &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" />
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:TextBox ID="txtUserID" runat="server" Text='<%# Bind("Entity_id") %>' Style="margin-left: 0px"
                                    Width="225px"></asp:TextBox>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="lblEmail" runat="server" CssClass="Regtxt" Text="Email"> </asp:Label>
                                &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" /></div>
                            <div class="DivTable2secondcol">
                                <asp:TextBox ID="txtEmail" runat="server" Text='<%# Bind("email") %>' Width="225px"></asp:TextBox>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="lblCountry" runat="server" CssClass="Regtxt" Text="Country & Region"> </asp:Label>
                                &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" />
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:DropDownList ID="DropDownListcountry" runat="server" Width="146px" Height="19px">
                                </asp:DropDownList>
                                <ajaxToolkit:CascadingDropDown ID="CascadingDropDown1" runat="server" TargetControlID="DropDownListcountry"
                                    Category="country" PromptText="Please select a country" LoadingText="[Loading Country...]"
                                    SelectedValue='<%# Bind("country") %>' ServicePath="~/services/regionService.asmx"
                                    ServiceMethod="Getcountry" />
                                &nbsp; -- &nbsp;
                                <asp:DropDownList ID="DropDownListregion" runat="server" Width="173px" Height="21px">
                                </asp:DropDownList>
                                <ajaxToolkit:CascadingDropDown ID="CascadingDropDown2" runat="server" TargetControlID="DropDownListregion"
                                    Category="region" PromptText="Please select a region" LoadingText="[Loading Region...]"
                                    SelectedValue='<%# Bind("region") %>' ServicePath="~/services/regionService.asmx"
                                    ServiceMethod="Getregion" ParentControlID="DropDownListcountry" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="DropDownListregion">* </asp:RequiredFieldValidator>
                                <ajaxToolkit:ValidatorCalloutExtender ID="ValidatorCalloutExtender6" runat="server"
                                    HighlightCssClass="ErrorStyle" TargetControlID="RequiredFieldValidator5">
                                </ajaxToolkit:ValidatorCalloutExtender>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                &nbsp;&nbsp;
                                <asp:Label ID="lblCity" runat="server" CssClass="Regtxt" Text="City"></asp:Label>
                                &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" />
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:TextBox ID="txtCity" runat="server" Text='<%# Bind("city") %>' Width="225px"></asp:TextBox>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                &nbsp;&nbsp;
                                <asp:Label ID="lblCompanyName" runat="server" CssClass="Regtxt" Text="CompanyName"></asp:Label>
                                &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" />
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:TextBox ID="txtCompanyName" runat="server" Text='<%# Bind("company_name") %>'
                                    Width="225px"></asp:TextBox>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                &nbsp;<asp:Label ID="lblPhone" runat="server" CssClass="Regtxt" Text="Phone"></asp:Label>
                                &nbsp;<img height="25" src="image/01_telephone_inv_thumb.gif" width="25" alt="" /></div>
                            <div class="DivTable2secondcol">
                                <asp:TextBox ID="txtCompanyPhone" runat="server" Text='<%# Bind("company_phone") %>'
                                    Width="225px"></asp:TextBox>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                &nbsp;<asp:Label ID="Label3" runat="server" CssClass="Regtxt" Text="Invoice Name"></asp:Label>
                                &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" />
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:TextBox ID="txtInvoiceName" runat="server" Text='<%# Bind("invoice_name") %>'
                                    Width="85%"></asp:TextBox>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                &nbsp;<asp:Label ID="Label5" runat="server" CssClass="Regtxt" Text="Invoice Address"></asp:Label>
                                &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" />
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:TextBox ID="txtInvoiceAddress" runat="server" Text='<%# Bind("invoice_address") %>'
                                    Width="85%"></asp:TextBox>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                &nbsp;<asp:Label ID="Label9" runat="server" CssClass="Regtxt" Text="Invoice Phone"></asp:Label>
                                &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" />
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:TextBox ID="txtInvoicePhone" runat="server" Text='<%# Bind("invoice_phone") %>'
                                    Width="85%"></asp:TextBox>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                &nbsp;<asp:Label ID="Label7" runat="server" CssClass="Regtxt" Text="Invoice Tax"></asp:Label>
                                &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" />
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:TextBox ID="txtInvoiceTax" runat="server" Text='<%# Bind("invoice_tax") %>'
                                    Width="225px"></asp:TextBox>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtInvoiceTax"
                                    ErrorMessage="Error: Please input valid tax" ValidationExpression="[0-9]+">*</asp:RegularExpressionValidator>
                                <ajaxToolkit:ValidatorCalloutExtender ID="ValidatorCalloutExtender1" runat="server"
                                    TargetControlID="RegularExpressionValidator2" HighlightCssClass="validatorCalloutHighlight">
                                </ajaxToolkit:ValidatorCalloutExtender>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="Label1" runat="server" CssClass="Regtxt" Text=""></asp:Label>
                                &nbsp;
                                <img height="25" src="image/51_rightarrow_inv_thumb.gif" alt="" width="25" />
                            </div>
                            <div class="DivTable2secondcol">
                                &nbsp;&nbsp;&nbsp;
                                <asp:Button ID="UpdateButton" Text="Update" CommandName="Update" runat="server" />
                                &nbsp;&nbsp;&nbsp;
                                <asp:Button ID="CancelButton" Text="Cancel" CommandName="Cancel" runat="server" CausesValidation="False" />
                            </div>
                        </div>
                    </div>
                    </div> </div>
                </EditItemTemplate>
            </asp:FormView>
            <div class="DivTableRow">
                <br />
                <asp:Label ID="labelMessage" runat="server" ForeColor="#FF3300"></asp:Label>
                <br />
                <asp:LinkButton ID="LinkButton1" Text="Back to Previous Page" OnClick="BacktoPreviousPage"
                    CssClass="LinkButtonStyle" runat="server" CausesValidation="False"></asp:LinkButton>
            </div>
        </asp:View>
    </asp:MultiView>
</asp:Content>
