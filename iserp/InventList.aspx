<%@ Page Title="" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true"
    CodeBehind="InventList.aspx.cs" Inherits="iserp.InventList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="Styles/ui-lightness/jquery-ui-1.8.14.custom.css" rel="stylesheet" type="text/css" />
    <script src="Scripts/ui/jquery-ui-1.8.14.js" type="text/javascript"></script>
    <script src="Scripts/ui/jquery.ui.core.js" type="text/javascript"></script>
    <script src="Scripts/ui/jquery.ui.widget.js" type="text/javascript"></script>
    <script src="Scripts/ui/jquery.ui.position.js" type="text/javascript"></script>
    <script src="Scripts/ui/jquery.ui.autocomplete.js" type="text/javascript"></script>
    <script src="Scripts/Autocomplete.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <br />
    <asp:Label ID="ErrorBox" runat="server" CssClass="LabelErrorMsg">    </asp:Label>
    <br />
    <div class="ui-widget">
        <asp:Label ID="lblSearch" Text="Part# Search" AssociatedControlID="txbSearchKeyword"
            runat="server"></asp:Label>
        <asp:TextBox ID="txbSearchKeyword" runat="server" CssClass="searchinput"></asp:TextBox>
        <asp:Button ID="Button1" Text="Go!" runat="server" OnClick="Search_Click" />
    </div>
    <br />
    <asp:GridView ID="GridView1" HorizontalAlign="Center" runat="server" AutoGenerateColumns="False"
        AllowPaging="True" PageSize="15" OnPageIndexChanging="GridView1_PageIndexChanging"
        Width="85%" DataKeyNames="part_no" CssClass="mGrid" EmptyDataText="No Data Currently"
        AlternatingRowStyle-CssClass="altRow">
        <Columns>
            <asp:BoundField DataField="part_no" HeaderText="Product NO" />
            <asp:BoundField DataField="part_name" HeaderText="Product Name" />
            <asp:BoundField DataField="qty" HeaderText="Quantity" />
            <%--<asp:BoundField DataField="unit" HeaderText="Unit" />--%>
            <%--<asp:BoundField DataField="category" HeaderText="Category" />--%>
        </Columns>
    </asp:GridView>
</asp:Content>
