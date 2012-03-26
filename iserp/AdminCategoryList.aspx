<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminCategoryList.aspx.cs" Inherits="iserp.AdminCategoryList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
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
</asp:Content>
