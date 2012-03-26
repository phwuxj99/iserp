<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="ErrorReport.aspx.cs" Inherits="iserp.ErrorReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit.HTMLEditor"
    TagPrefix="HTMLEditor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="DivTableEmail">
        <div class="DivTableRowEmail">
            <h3>
                <asp:Label ID="lblEmailUs" runat="server" Text="Thank you for Email the Error to Admin:" CssClass="LabelWarning"></asp:Label>
            </h3>
        </div>
        <div class="DivTableRowEmail">
            <asp:Label ID="lblRequired1" runat="server"></asp:Label>
            <asp:Label ID="lblRequired2" runat="server"></asp:Label>
        </div>
        <div class="DivTableRow">
            <div class="DivTable2firstcolEmail">
                <asp:Label ID="lblName" runat="server" Text="Name"></asp:Label><span style="color: #cc0000">*</span>
            </div>
            <div class="DivTable2secondcolEmail">
                <asp:TextBox ID="txbName" Width="225px" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Empty: Your Name?"
                    ControlToValidate="txbName">*</asp:RequiredFieldValidator>
                <ajaxToolkit:ValidatorCalloutExtender ID="ValidatorCalloutExtender1" runat="server"
                    HighlightCssClass="ErrorStyle" TargetControlID="RequiredFieldValidator1">
                </ajaxToolkit:ValidatorCalloutExtender>
            </div>
        </div>
        <div class="DivTableRow">
            <div class="DivTable2firstcolEmail">
                <asp:Label ID="lblEmail" runat="server" Text="Email"></asp:Label>
                <span style="color: #cc0000">*</span>
            </div>
            <div class="DivTable2secondcolEmail">
                <asp:TextBox ID="txtEmail" Width="225px" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Error: Email address"
                    ControlToValidate="txtEmail">*</asp:RequiredFieldValidator>
                <ajaxToolkit:ValidatorCalloutExtender ID="ValidatorCalloutExtender3" runat="server"
                    HighlightCssClass="ErrorStyle" TargetControlID="RequiredFieldValidator2">
                </ajaxToolkit:ValidatorCalloutExtender>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Error: Email Address"
                    ValidationExpression="[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"
                    ControlToValidate="txtEmail">*</asp:RegularExpressionValidator>
                <ajaxToolkit:ValidatorCalloutExtender ID="ValidatorCalloutExtender5" runat="server"
                    HighlightCssClass="ErrorStyle" TargetControlID="RegularExpressionValidator1">
                </ajaxToolkit:ValidatorCalloutExtender>
            </div>
        </div>
        <div class="DivTableRow">
            <div class="DivTable2firstcolEmail">
                <asp:Label ID="lblCompany" runat="server" Text="Subject"></asp:Label>
            </div>
            <div class="DivTable2secondcolEmail">
                <asp:TextBox ID="txbCompany" Width="225px" runat="server"></asp:TextBox>
            </div>
        </div>
        <div class="DivTableRow">
            <div class="DivTable2firstcolEmail">
                <asp:Label ID="lblMessage" runat="server" Text="Message:"></asp:Label>
            </div>
            <div class="DivTable2secondcolEmail">
                <asp:Label ID="Label1" runat="server" Text=" "></asp:Label>
            </div>
        </div>
        <div class="DivTableRow">
            <%-- <div class="DivTable2firstcolEmail">--%>
            <%-- </div>
            <div class="DivTable2secondcolEmail">--%>
            <%--<asp:TextBox ID="txbMessage" Width="288px" runat="server" Height="200px" TextMode="MultiLine"></asp:TextBox>--%>
            <HTMLEditor:Editor runat="server" ID="editor" Height="300px" AutoFocus="true" Width="100%" />
            <br />
            <%-- </div>--%>
        </div>
        <div class="DivTableRow">
            <asp:Button ID="SendButton" OnClick="btnSend_Click" runat="server" Text="Submit" />
            <br />
            <asp:Label ID="ErrorMsg" CssClass="LabelErrorMsg" runat="server" Text=""></asp:Label>
        </div>
        <br />
    </div>
    <br />
    <br />
</asp:Content>
