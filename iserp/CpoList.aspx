<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="CpoList.aspx.cs" Inherits="iserp.CpoList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <p align="center" class="green">
        <font color="#0000ff" size="4">CPO List</font>
    </p>
    <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">
        <asp:View ID="View1" runat="server">
            <asp:GridView ID="GridView1" HorizontalAlign="Center" runat="server" AutoGenerateColumns="False"
                AllowPaging="True" PageSize="15" OnPageIndexChanging="GridView1_PageIndexChanging"
                Width="85%" DataKeyNames="key" CssClass="mGrid" OnRowCommand="LoadDetails" EmptyDataText="No Data Currently"
                AlternatingRowStyle-CssClass="altRow">
                <Columns>
                    <asp:BoundField DataField="key" HeaderText="CPONO" ReadOnly="false" SortExpression="cpono" />
                    <asp:BoundField DataField="podate" HeaderText="Created DATE" ReadOnly="false" SortExpression="op_date"
                        DataFormatString="{0:MMM/dd/yyyy}" />
                    <asp:ButtonField ButtonType="Link" CommandName="Details" HeaderText="Details" Text="Details" />
                </Columns>
            </asp:GridView>
        </asp:View>
        <asp:View ID="View2" runat="server">
            <asp:Label ID="EntityIDhide" runat="server" Visible="false" Text="" Font-Bold="true"></asp:Label>
            <br />
            <div class="DivTable">
                <div class="DivTableRow">
                    <div class="DivTable2firstcol">
                        <asp:Label ID="receiptdocument" runat="server" Text="CPO NO:" Font-Bold="True" Font-Size="Small"></asp:Label>
                    </div>
                    <div class="DivTable2secondcol">
                        <asp:Label ID="CPO_no" runat="server" Font-Bold="True" Font-Size="Small">
                        </asp:Label>
                    </div>
                </div>
            </div>
            <asp:GridView ID="GridView2" AutoGenerateColumns="false" DataKeyNames="id_num" runat="server"
                HorizontalAlign="Center" Width="85%">
                <Columns>
                    <asp:BoundField DataField="itemno" HeaderText="SN#" SortExpression="itemno" />
                    <asp:BoundField DataField="part_no" HeaderText="PART#" ReadOnly="false" SortExpression="part_no" />
                    <asp:BoundField DataField="qty" HeaderText="QTY" ReadOnly="true" />
                    <asp:BoundField DataField="cname" HeaderText="Customer" ReadOnly="false" />
                    <asp:BoundField DataField="cpono" HeaderText="CPONO" ReadOnly="false" />
                </Columns>
            </asp:GridView>
            <div class="DivTable">
                <div class="DivTableRow">
                    <div class="DivTable2firstcol">
                        <asp:Label ID="Label1" Text="INV#:" runat="server"></asp:Label>
                    </div>
                    <div class="DivTable2secondcol">
                        <asp:TextBox ID="txbINV" runat="server" Width="100px"></asp:TextBox>
                        &nbsp;&nbsp;
                        <asp:Button ID="LogButton" Text="Add To Invoice" SkinID="ASPButton" runat="Server"
                            OnClick="AddtoInventory" Width="155px" ValidationGroup="wr_input"  />
                        &nbsp;
                        <asp:Label ID="Message" runat="server"></asp:Label>
                    </div>
                </div>
                <div class="DivTableRow"><br /><br />
                    <asp:LinkButton ID="LinkButton1" Text="Back to Previous Page" OnClick="BacktoPreviousPage"
                        CssClass="LinkButtonStyle" runat="server" CausesValidation="False"></asp:LinkButton>
                </div>
            </div>
        </asp:View>
    </asp:MultiView>
</asp:Content>
