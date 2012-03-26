<%@ Page Title="" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" EnableEventValidation="false"
    CodeBehind="ClientSearch.aspx.cs" Inherits="iserp.ClientSearch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <br />
    <asp:Label ID="ErrorBox" runat="server" CssClass="LabelErrorMsg">    </asp:Label>
    <div class="ui-widget">
        <asp:Label ID="lblSearch" Text="Client Name Search: " AssociatedControlID="txbSearchKeyword"
            runat="server"></asp:Label>
        <asp:TextBox ID="txbSearchKeyword" runat="server" CssClass="searchinput"></asp:TextBox>
        <asp:Button ID="Button1" Text="Go!" runat="server" OnClick="Search_Click" />
    </div>
    <br />
    <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">
        <asp:View ID="View1" runat="server">
            <asp:GridView ID="GridView1" HorizontalAlign="Center" runat="server" AutoGenerateColumns="False"
                AllowPaging="True" PageSize="15" OnPageIndexChanging="GridView1_PageIndexChanging"
                Width="85%" DataKeyNames="cname_code" CssClass="mGrid" OnRowCommand="LoadDetails"
                EmptyDataText="No Data Currently" AlternatingRowStyle-CssClass="altRow">
                <Columns>
                    <asp:BoundField DataField="cname" HeaderText="Client Name" />
                    <asp:BoundField DataField="cname_code" HeaderText="Client Code" />
                    <asp:BoundField DataField="contact" HeaderText="Contact" />
                    <asp:BoundField DataField="tel" HeaderText="Phone" />
                    <asp:BoundField DataField="State" HeaderText="Province" />
                    <asp:ButtonField ButtonType="Link" CommandName="Details" HeaderText="Details" Text="Details" />
                    <asp:HyperLinkField HeaderText="." Text="Edit" DataNavigateUrlFields="cname_code"
                            DataNavigateUrlFormatString="ClientUpdate.aspx?IDCnameCode={0}" />
                </Columns>
            </asp:GridView>
            <br />
        </asp:View>
        <asp:View ID="View2" runat="server">
            <asp:Label ID="EntityIDhide" runat="server" Visible="false" Text="" Font-Bold="true"></asp:Label>
            <br />
            <asp:FormView ID="FormView1" DataKeyNames="cname_code" runat="server" OnItemUpdating="FormView1_ItemUpdating"
                OnModeChanging="FormView1_ModeChanging" CssClass="FormViewStyle FormViewWidth"
                HorizontalAlign="Center" OnItemInserting="FormView1_Inserting" OnModeChanged="FormView1_ModeChanged"
                OnItemCommand="FormView1_ItemCommand">
                <ItemTemplate>
                    <div class="DivTable">
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <font color="#000000"><b>&nbsp;Client Name</b></font>:
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="Label17" runat="server" Text='<%# Bind("cname") %>'></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <font color="#000000"><b>&nbsp;Client Code</b></font>:
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="Label18" runat="server" Text='<%# Bind("cname_code") %>'></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <strong><font face="Verdana" color="#000000" size="1">Contact Person </font></strong>
                                :
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="Label1" runat="server" Text='<%# Bind("contact") %>'></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <font color="#000000"><b><font face="Verdana" size="1">Contact Phone </font></b>
                                </font>:
                            </div>
                            <div class="DivTable2secondcol">
                                 <asp:Label ID="Label2" Text='<%# Bind("tel") %>' CssClass="Normal" runat="server"
                                            Visible="true"></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <strong><font face="Verdana" color="#000000" size="1">Fax </font></strong>:
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="Label3" runat="server" Text='<%# Bind("fax") %>' CssClass="Normal"></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Address </font>
                                </strong>:
                            </div>
                            <div class="DivTable2secondcol">
                                 <asp:Label ID="Label4" runat="server" Text='<%# Bind("address") %>' CssClass="Normal"></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <strong><font face="Verdana" size="1">City :</font></strong>
                            </div>
                            <div class="DivTable2secondcol">
                               <asp:Label ID="Label5" Text='<%# Bind("city") %>' CssClass="Normal" runat="server"
                                            Visible="true"></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <strong><font face="Verdana" color="#000000" size="1">Country :</font></strong>
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="Label7" runat="server" Text='<%# Bind("country") %>' CssClass="Normal"></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <strong><font face="Verdana" color="#000000" size="1">Region :</font></strong>
                            </div>
                            <div class="DivTable2secondcol">
                               <asp:Label ID="Label8" runat="server" Text='<%# Bind("state") %>' CssClass="Normal"></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <font color="#000000"><b><font face="Verdana" size="1">Post Code :</font></b></font>
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="Label6" runat="server" Text='<%# Bind("postcode") %>' CssClass="Normal"></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <strong><font face="Verdana" size="1">E-Mail Address </font></strong>:
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="lblBomname" runat="server" Text='<%# Bind("email") %>' CssClass="Normal"></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <strong><font face="Verdana" size="1">TAX(%) </font></strong>:
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="Label9" runat="server" Text='<%# Bind("invoice_tax") %>' CssClass="Normal"></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <font color="#000000"><b><font face="Verdana" size="1">&nbsp;Web Page :</font></b></font>
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="lblDrawingno" runat="server" Text='<%# Bind("website") %>' CssClass="Normal"></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                Note :
                            </div>
                            <div class="DivTable2secondcol">
                               <asp:Label ID="lblNotes" runat="server" Text='<%# Bind("notes") %>' CssClass="Normal"></asp:Label>
                            </div>
                        </div>
                        <%--<div class="DivTableRow">
                            <div class="DivTable2firstcol">
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Button runat="server" Text="Confirm" SkinID="ASPButton" ID="LogButton" OnClick="AddAuthor_Click"
                                    Width="97px" />&nbsp;&nbsp;&nbsp;
                                <asp:Label ID="Message" CssClass="LabelErrorMsg" runat="server"></asp:Label>
                            </div>
                        </div>--%>
                    </div>
                </ItemTemplate>
            </asp:FormView>
            <div align="center">
                <asp:LinkButton ID="LinkButton1" Text="Back to Previous Page" OnClick="BacktoPreviousPage"
                    CssClass="LinkButtonStyle" runat="server" CausesValidation="False"></asp:LinkButton>
            </div>
        </asp:View>
    </asp:MultiView>
</asp:Content>
