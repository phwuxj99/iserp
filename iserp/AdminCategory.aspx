<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="AdminCategory.aspx.cs" Inherits="iserp.AdminCategory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script runat="server">
  //protected void Page_Init(object sender, EventArgs e)
  //{
  //  DynamicDataManager1.RegisterControl(ListView1);
  //}
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Category List</h2>
    <div style="float: left; margin-right: 20px; width: 100%">
        <asp:EntityDataSource ID="InstructorsEntityDataSource" runat="server" ContextTypeName="iserp.shared.Entities"
            EnableFlattening="False" EntitySetName="categories" EnableUpdate="True" ConnectionString="name=Entities"
            DefaultContainerName="Entities">
        </asp:EntityDataSource>
        <asp:GridView ID="InstructorsGridView" runat="server" AllowPaging="True" AllowSorting="True"
            AutoGenerateColumns="False" DataKeyNames="id_num" DataSourceID="InstructorsEntityDataSource"
            OnSelectedIndexChanged="InstructorsGridView_SelectedIndexChanged" SelectedRowStyle-BackColor="LightGray"
            OnRowUpdating="InstructorsGridView_RowUpdating">
            <Columns>
                <asp:CommandField ShowSelectButton="True" ShowEditButton="True" />
                <asp:BoundField DataField="id_num" HeaderText="id_num" SortExpression="id_num" ReadOnly="true" />
                <asp:BoundField DataField="category_name" HeaderText="Category Name" SortExpression="category_name" />
                <asp:BoundField DataField="description" HeaderText="Description" SortExpression="description" />
                <asp:BoundField DataField="operator" HeaderText="operator" SortExpression="operator" />
            </Columns>
            <SelectedRowStyle BackColor="LightGray"></SelectedRowStyle>
        </asp:GridView>
    </div>
    <div style="float: left; margin-right: 20px; width: 100%">
        <h2>
            Add Category</h2>
        <asp:EntityDataSource ID="StudentsEntityDataSource" runat="server" ContextTypeName="iserp.shared.Entities"
            EnableFlattening="False" EntitySetName="categories" EnableInsert="True" ConnectionString="name=Entities"
            DefaultContainerName="Entities" EnableDelete="True" EnableUpdate="True">
        </asp:EntityDataSource>
        <asp:DetailsView ID="StudentsDetailsView" runat="server" DataSourceID="StudentsEntityDataSource"
            AutoGenerateRows="False" DefaultMode="Insert" DataKeyNames="id_num">
            <Fields>
                <%--<asp:BoundField DataField="id_num" HeaderText="id_num" SortExpression="id_num" ReadOnly="true" />--%>
                <asp:BoundField DataField="category_name" HeaderText="Category Name" SortExpression="category_name" />
                <asp:BoundField DataField="description" HeaderText="Description" SortExpression="description" />
                <asp:BoundField DataField="operator" HeaderText="operator" SortExpression="operator" />
                <asp:CommandField ShowInsertButton="True" />
            </Fields>
        </asp:DetailsView>
    </div>
</asp:Content>
