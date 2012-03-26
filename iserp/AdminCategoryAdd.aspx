<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminCategoryAdd.aspx.cs" Inherits="iserp.AdminCategoryAdd" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
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
</asp:Content>
