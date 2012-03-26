<%@ Page Title="Add New Product" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true"
    CodeBehind="PartnoNew.aspx.cs" Inherits="iserp.PartnoNew" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <div class="demoarea">
        <p align="center" class="green">
            <font color="#0000ff" size="4">Add New Product&nbsp; </font>
        </p>
        <br />
        <div class="DivTable">
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <asp:Label ID="Label1" runat="server" Text="Product No.:"></asp:Label>&nbsp;&nbsp;
                </div>
                <div class="DivTable2secondcol">
                    <asp:TextBox ID="part_no" runat="server" Width="225px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="part_no"
                        ErrorMessage="Part No. not allow empty">*</asp:RequiredFieldValidator>
                    <ajaxToolkit:ValidatorCalloutExtender ID="ValidatorCalloutExtender2" runat="server"
                        TargetControlID="RequiredFieldValidator1" HighlightCssClass="validatorCalloutHighlight">
                    </ajaxToolkit:ValidatorCalloutExtender>
                </div>
            </div>
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <asp:Label ID="Label2" runat="server" Text="Product Name:"></asp:Label>&nbsp;&nbsp;
                    </div>
                <div class="DivTable2secondcol">
                    <asp:TextBox ID="part_name" runat="server" Width="225px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="part_name"
                        ErrorMessage="Part Name not allow empty">*</asp:RequiredFieldValidator></div>
            </div>
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <asp:Label ID="Label3" runat="server" Text="Product Description:"></asp:Label>&nbsp;&nbsp;
                </div>
                <div class="DivTable2secondcol">
                    <textarea id="part_description" runat="server" cols="44" rows="2" style="width: 398px"></textarea>
                </div>
            </div>
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <asp:Label ID="Label4" runat="server" Text="Unit:"></asp:Label>&nbsp;&nbsp;
                </div>
                <div class="DivTable2secondcol">
                    <asp:TextBox ID="unit" runat="server" Width="125px"></asp:TextBox>
                </div>
            </div>
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <asp:Label ID="Label5" runat="server" Text="Category:"></asp:Label>&nbsp;&nbsp;
                </div>
                <div class="DivTable2secondcol">
                    <asp:DropDownList ID="DropDownListcategory" SkinID="ASPDropDownList" runat="server"
                        AppendDataBoundItems="false" AutoPostBack="false">
                        <%--<asp:ListItem Value="0">A</asp:ListItem>
                        <asp:ListItem Value="1">B</asp:ListItem>--%>
                    </asp:DropDownList>
                </div>
            </div>
            <%--<div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <asp:Label ID="Label6" runat="server" Text="Brand:"></asp:Label>
                </div>
                <div class="DivTable2secondcol">
                    <asp:DropDownList ID="ddlBrand" Width="125px" runat="server" />
                    <ajaxToolkit:CascadingDropDown ID="CascadingDropDown1" runat="server" Category="Brand" TargetControlID="ddlBrand"
                        PromptText=" - Brand - " LoadingText="Loading Brand..." ServicePath="WebService.asmx"
                        ServiceMethod="GetDropDownValues">
                    </ajaxToolkit:CascadingDropDown>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:DropDownList ID="ddlSeries" Width="155px" runat="server" />
                    <ajaxToolkit:CascadingDropDown ID="CascadingDropDown2" runat="server" Category="Series" TargetControlID="ddlSeries"
                        ParentControlID="ddlBrand" PromptText=" - Series - " LoadingText="Loading Series..."
                        ServicePath="WebService.asmx" ServiceMethod="GetDropDownValues">
                    </ajaxToolkit:CascadingDropDown>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:DropDownList ID="ddlModel" Width="115px" runat="server" />
                    <ajaxToolkit:CascadingDropDown ID="CascadingDropDown3" runat="server" Category="Model" TargetControlID="ddlModel"
                        ParentControlID="ddlSeries" PromptText=" - Model -" LoadingText="Loading Model..."
                        ServicePath="WebService.asmx" ServiceMethod="GetDropDownValues">
                    </ajaxToolkit:CascadingDropDown>
                </div>
            </div>--%>
            <%--<div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <asp:Label ID="Label11" runat="server" Text="OutputValue:"></asp:Label>
                </div>
                <div class="DivTable2secondcol">
                    <textarea id="outputvalue" runat="server" cols="44" rows="2" style="width: 398px"
                        name="S1"></textarea>
                </div>
            </div>
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <asp:Label ID="Label7" runat="server" Text="Compatible:"></asp:Label>
                </div>
                <div class="DivTable2secondcol">
                    <textarea id="compatible" runat="server" cols="44" rows="2" style="width: 398px"
                        name="S1"></textarea>
                </div>
            </div>--%>
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <asp:Label ID="Label8" runat="server" Text="Sales Price($):"></asp:Label>&nbsp;&nbsp;
                </div>
                <div class="DivTable2secondcol">
                    <asp:TextBox ID="price1" runat="server" Text="0.00" Width="125px"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="price1"
                        ErrorMessage="Error: Please input valid price" ValidationExpression="^[-+]?[0-9]\d{0,2}(\.\d{1,2})?%?$">*</asp:RegularExpressionValidator>
                    <ajaxToolkit:ValidatorCalloutExtender ID="ValidatorCalloutExtender1" runat="server"
                        TargetControlID="RegularExpressionValidator2" HighlightCssClass="validatorCalloutHighlight">
                    </ajaxToolkit:ValidatorCalloutExtender>
                </div>
            </div>
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <asp:Label ID="Label6" runat="server" Text="Cost Price($):"></asp:Label>&nbsp;&nbsp;
                </div>
                <div class="DivTable2secondcol">
                    <asp:TextBox ID="price2" runat="server" Text="0.00" Width="125px"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ControlToValidate="price2"
                        ErrorMessage="Error: Please input valid price" ValidationExpression="^[-+]?[0-9]\d{0,2}(\.\d{1,2})?%?$">*</asp:RegularExpressionValidator>
                    <ajaxToolkit:ValidatorCalloutExtender ID="ValidatorCalloutExtender3" runat="server"
                        TargetControlID="RegularExpressionValidator3" HighlightCssClass="validatorCalloutHighlight">
                    </ajaxToolkit:ValidatorCalloutExtender>
                </div>
            </div>
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <asp:Label ID="Label9" runat="server" Text="Weight:"></asp:Label>&nbsp;&nbsp;
                </div>
                <div class="DivTable2secondcol">
                    <asp:TextBox ID="weight" runat="server" Width="125px">0</asp:TextBox>(LB)
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="weight"
                        ErrorMessage="Weight: Please input valid Number" ValidationExpression="^[-+]?[0-9]\d{0,2}(\.\d{1,2})?%?$">*</asp:RegularExpressionValidator>
                </div>
            </div>
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <asp:Label ID="Label10" runat="server" Text="Note:"></asp:Label>&nbsp;&nbsp;
                </div>
                <div class="DivTable2secondcol">
                    <textarea id="notes" runat="server" cols="44" rows="5" style="width: 398px;"></textarea>
                </div>
            </div>
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                </div>
                <div class="DivTable2secondcol">
                    &nbsp;<asp:Button ID="LogButton" Text="Confirm" OnClick="LogButton_OnClick" runat="Server"
                        Width="65px" />&nbsp;&nbsp;&nbsp;
                    <asp:Label ID="Message" runat="server" CssClass="LabelErrorMsg"></asp:Label>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
