<%@ Page Title="" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true"
    CodeBehind="InventRecChk.aspx.cs" Inherits="iserp.InventRecChk" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <p align="center" class="green">
        <font color="#0000ff" size="4">Inventory Receipt List</font>
    </p>
    <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">
        <asp:View ID="View1" runat="server">
            <asp:GridView ID="GridView1" HorizontalAlign="Center" runat="server" AutoGenerateColumns="False"
                AllowPaging="True" PageSize="15" OnPageIndexChanging="GridView1_PageIndexChanging"
                Width="85%" DataKeyNames="key" CssClass="mGrid" OnRowCommand="LoadDetails" EmptyDataText="No Data Currently"
                AlternatingRowStyle-CssClass="altRow">
                <Columns>
                    <asp:BoundField DataField="key" HeaderText="Receipt NO" ReadOnly="false" />
                    <asp:BoundField DataField="podate" HeaderText="DATE" ReadOnly="false" />
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
                        <asp:Label ID="receiptdocument" runat="server" Text="Receipt NO:" Font-Bold="True"
                            Font-Size="Small"></asp:Label>
                    </div>
                    <div class="DivTable2secondcol">
                        <asp:Label ID="receipt_no" runat="server" Font-Bold="True" Font-Size="Small">
                        </asp:Label>
                    </div>
                </div>
            </div>
            <asp:GridView ID="GridView2" AutoGenerateColumns="false" DataKeyNames="id_num" runat="server"
                HorizontalAlign="Center" Width="85%">
                <Columns>
                    <asp:BoundField HeaderText="SN" DataField="id_num" />
                    <asp:BoundField HeaderText="Product #" DataField="part_no" />
                    <asp:BoundField HeaderText="Name" DataField="part_name" />
                    <asp:BoundField HeaderText="Quantity" DataField="qty" />
                    <asp:BoundField HeaderText="Supplier" DataField="supplier_code" />
                    <asp:BoundField DataField="podate" HeaderText="DATE" ReadOnly="false" />
                </Columns>
            </asp:GridView>
            <div class="DivTable">
                <div class="DivTableRow">
                    <div class="DivTable2firstcol">
                    </div>
                    <div class="DivTable2secondcol">
                        <asp:Button ID="LogButton" Text="Add To Inventory" SkinID="ASPButton" runat="Server"
                            OnClick="AddtoInventory" Width="155px" ValidationGroup="wr_input" />
                        &nbsp;
                        <asp:Label ID="Message" runat="server"></asp:Label>
                    </div>
                </div>
                <div class="DivTable2firstcol">
                </div>
                <div class="DivTable2secondcol">
                    <asp:LinkButton ID="LinkButton1" Text="Back to Previous Page" OnClick="BacktoPreviousPage"
                        CssClass="LinkButtonStyle" runat="server" CausesValidation="False"></asp:LinkButton>
                </div>
            </div>
        </asp:View>
    </asp:MultiView>
</asp:Content>
