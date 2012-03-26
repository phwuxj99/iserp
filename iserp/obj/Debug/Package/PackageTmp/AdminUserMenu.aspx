<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="AdminUserMenu.aspx.cs" Inherits="iserp.AdminUserMenu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <br />
    <br />
    <asp:Label ID="Label1" runat="server" Text="Select User: "></asp:Label>
    <asp:DropDownList ID="DropDownListUsers" SkinID="ASPDropDownList" AppendDataBoundItems="true"
        OnSelectedIndexChanged="OnSelectedIndex_Changed" AutoPostBack="true" runat="server">
        <asp:ListItem Value="">-- ALL User--</asp:ListItem>
    </asp:DropDownList>
    &nbsp;&nbsp;
    <asp:Button ID="Button1" runat="server" Text="Partial Menu Set" SkinID="ASPButton"
        OnClick="btnButton1_click" />
    &nbsp;&nbsp;
    <asp:Button ID="Button2" runat="server" Text="All Menu Set" SkinID="ASPButton" OnClick="btnButton2_click" />
    <br />
    <br />
    <%--<asp:UpdatePanel ID="updatepanela" runat="server">
        <ContentTemplate>--%>
    <div>
        <asp:Label ID="Message" runat="server" CssClass="LabelErrorMsg" Text=""></asp:Label>
        <%--<asp:Button ID="btnUpdate" runat="server" OnClick="btnUpdate_Click" Text="Update"
                    Width="120" />--%>
        <br />
        <asp:GridView runat="server" ID="grd" AutoGenerateColumns="false" DataKeyNames="MenuID"
            Width="85%" OnRowDataBound="OnDataBound">
            <Columns>
                <asp:BoundField DataField="MenuID" HeaderText="Menu ID" />
                <asp:TemplateField HeaderText="Menu Name" SortExpression="Name">
                    <ItemTemplate>
                        <asp:TextBox ID="txtName" runat="server" Text='<%# Bind("Text") %>' ForeColor="Blue"
                            BorderStyle="none" BorderWidth="0px" ReadOnly="true">
                        </asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="CheckAll">
                    <ItemTemplate>
                        <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="true" OnCheckedChanged="chkSelectAll_CheckedChanged2" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Child Grid">
                    <ItemTemplate>
                        <asp:GridView runat="server" ID="ChldGrid" AutoGenerateColumns="false" DataKeyNames="MenuID"
                            Width="100%">
                            <Columns>
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <asp:CheckBox runat='server' ID="chk" AutoPostBack="true" Checked='<%#Convert.ToBoolean(Eval("menu_name")) %>'
                                            OnCheckedChanged="chkSelect_CheckedChanged" Width="125px" Text='<%# Eval("menu_name").ToString().Equals("1") ? " Approved " : " Not Approved " %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ID">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtMenuID" runat="server" Text='<%# Bind("MenuID") %>' ReadOnly="true"
                                            Width="35px" ForeColor="Blue" BorderStyle="none" BorderWidth="0px">
                                        </asp:TextBox>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Menu Name">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtName" runat="server" Text='<%# Bind("Text") %>' ReadOnly="true"
                                            ForeColor="Blue" BorderStyle="none" BorderWidth="0px">
                                        </asp:TextBox>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
    <%-- </ContentTemplate>
    </asp:UpdatePanel>--%>
</asp:Content>
