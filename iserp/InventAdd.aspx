<%@ Page Title="" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true"
    CodeBehind="InventAdd.aspx.cs" Inherits="iserp.InventAdd" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="Styles/jquery.autocomplete.css" rel="stylesheet" type="text/css" />
    <script src="Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <script src="Scripts/jquery.autocomplete.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var cc = '<%=ListPartnos%>'.split("|");
            $("#autoText").autocomplete(cc);
            $("#autoText").focus;
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <p align="center" class="green">
        <font color="#0000ff" size="4">Input Inventory Receipt </font>
    </p>
    <div style="text-align: center">
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" HeaderText="You must enter a value in the following fields"
            DisplayMode="List" />
        <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">
            <asp:View ID="View1" runat="server">
                Please Input Receipt NO. :
                <asp:TextBox ID="receiptTXT" runat="server" Width="100px"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="receiptTXT"
                    ErrorMessage="Please Input the receipt NO." ValidationGroup="abc">*</asp:RequiredFieldValidator>
                &nbsp;
                <asp:Button ID="Button1" Text="Confirm" SkinID="ASPButton" OnClick="Button1_Click"
                    ValidationGroup="abc" runat="Server" Width="65px" />&nbsp;
            </asp:View>
            <asp:View ID="View2" runat="server">
                <asp:Label ID="receiptdocument" runat="server" Text="Receipt Document NO:" Font-Bold="True"
                    Font-Size="Small"></asp:Label>
                &nbsp;
                <asp:Label ID="receipt_no" runat="server" Font-Bold="True" Font-Size="Small"></asp:Label>
                <div class="DivTable">
                    <div class="DivTableRow">
                        <div class="DivTable2firstcol">
                            Part No. :
                        </div>
                        <div class="DivTable2secondcol">
                            <input type="text" id="autoText" name="autoText" value="" />
                        </div>
                    </div>
                    <div class="DivTableRow">
                        <div class="DivTable2firstcol">
                            Quantity :
                        </div>
                        <div class="DivTable2secondcol">
                            <asp:TextBox ID="quantity" runat="server" Width="85px"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="quantity"
                                ErrorMessage="Quantity not allow empty">*</asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Numberic Only"
                                Display="None" ControlToValidate="quantity" ValidationExpression="\d+"></asp:RegularExpressionValidator>
                            <ajaxToolkit:ValidatorCalloutExtender runat="Server" ID="ValidatorCalloutExtender1"
                                TargetControlID="RegularExpressionValidator1" HighlightCssClass="validatorCalloutHighlight"
                                Width="230px">
                            </ajaxToolkit:ValidatorCalloutExtender>
                        </div>
                    </div>
                    <div class="DivTableRow">
                        <div class="DivTable2firstcol">
                            Supplier :
                        </div>
                        <div class="DivTable2secondcol">
                            <asp:TextBox ID="supplier" runat="server" Width="125px"></asp:TextBox>
                            <%--<asp:DropDownList ID="DropDownListsupplier" runat="server" AppendDataBoundItems="True"
                                    SkinID="ASPDropDownList" Width="155px" OnSelectedIndexChanged="DropDownListsupplier_SelectedIndexChanged"
                                    AutoPostBack="true">
                                    <asp:ListItem Value="">-- ALL Supplier--</asp:ListItem>
                                </asp:DropDownList>
                                &nbsp;
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="supplier"
                                    Display="Dynamic" ErrorMessage="Please Select Supplier">*</asp:RequiredFieldValidator>&nbsp;--%>
                        </div>
                    </div>
                    <%--<div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                (Option)&nbsp;Order# :
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:TextBox ID="OrderNumber" runat="server" Width="85px"></asp:TextBox>
                                &nbsp;&nbsp; Date:
                                <asp:TextBox ID="DateTextBox" runat="server" Width="80" />
                                <cc1:calendarextender id="CalendarExtender2" runat="server" format="MM/dd/yyyy" targetcontrolid="DateTextBox">
                                </cc1:calendarextender>
                                <cc1:textboxwatermarkextender id="TextBoxWatermarkExtender2" runat="server" targetcontrolid="DateTextBox"
                                    watermarktext="Click here" watermarkcssclass="watermark">
                                </cc1:textboxwatermarkextender>
                            </div>
                        </div>--%>
                    <div class="DivTableRow">
                        <div class="DivTable2firstcol">
                        </div>
                        <div class="DivTable2secondcol">
                            <asp:Button ID="LogButton" Text="Confirm" OnClick="LogButton_Click" SkinID="ASPButton"
                                runat="Server" Width="65px" />
                            <asp:Label ID="Message" runat="server" CssClass="LabelErrorMsg"></asp:Label>
                        </div>
                    </div>
                </div>
                <br />
                <asp:GridView ID="GridView1" AutoGenerateDeleteButton="true" OnRowDeleting="GridView1_OnRowDeleting"
                    AutoGenerateColumns="false" DataKeyNames="id_num" runat="server" HorizontalAlign="Center"
                    EmptyDataText="No Data Currently" SkinID="SampleGridView" OnRowDataBound="GridView1_RowDataBound"
                    Width="85%">
                    <Columns>
                        <asp:BoundField HeaderText="SN" DataField="id_num" />
                        <asp:BoundField HeaderText="Part#" DataField="part_no" />
                        <asp:BoundField HeaderText="Quantity" DataField="qty" />
                        <%--<asp:BoundField HeaderText="Receipt#" DataField="whre_no" />--%>
                        <asp:BoundField HeaderText="Supplier" DataField="supplier_code" />
                    </Columns>
                </asp:GridView>
            </asp:View>
        </asp:MultiView>
    </div>
</asp:Content>
