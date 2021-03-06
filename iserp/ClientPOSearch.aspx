﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" enableEventValidation="false"
    CodeBehind="ClientPOSearch.aspx.cs" Inherits="iserp.ClientPOSearch" %>

<%@ Register Assembly="GridViewPrn" Namespace="GridViewPrn" TagPrefix="wc" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript" language="javascript">        // <![CDATA[
        function print() {
            pvwindow = window.open('', 'PrintWindow', ' location = 0, status = 0, scrollbars = 1, width = 870, height = 800')
            pvwindow.document.write("<html>");
            pvwindow.document.write("<head>");
            pvwindow.document.write("<link href='App_Themes/Basic/DIVStyleSheet.css' rel='stylesheet' type='text/css' />");
            pvwindow.document.write("</head>");
            pvwindow.document.write("<body   style='background-color:white;' onload='window.print();'>");
            pvwindow.document.write(document.getElementById("divPrint").innerHTML);
            //here pass your div id which can u print
            pvwindow.document.write("</body>");
            pvwindow.document.write("</html>");
            pvwindow.document.close();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <p align="center" class="green">
        <font color="#0000ff" size="4">Customers Purchase Order Search </font>
    </p>
    <asp:Label ID="Label2" Text="&nbsp; Country:" runat="server"></asp:Label>
    <asp:DropDownList ID="DropDownListcountry" runat="server" Width="146px" Height="19px">
    </asp:DropDownList>
    <ajaxToolkit:CascadingDropDown ID="CascadingDropDown1" runat="server" TargetControlID="DropDownListcountry"
        SelectedValue="2" Category="country" PromptText="Please select a country" LoadingText="[Loading Country...]"
        ServicePath="Services/regionService.asmx" ServiceMethod="Getcountry" />
    <asp:Label ID="Label3" Text="&nbsp;Region:" runat="server"></asp:Label>
    <asp:DropDownList ID="DropDownListregion" runat="server" Width="173px" Height="21px"
        AutoPostBack="true" OnSelectedIndexChanged="ClientChangeRegion">
    </asp:DropDownList>
    <ajaxToolkit:CascadingDropDown ID="CascadingDropDown2" runat="server" TargetControlID="DropDownListregion"
        SelectedValue="55" Category="region" PromptText="Please select a region" LoadingText="[Loading Region...]"
        ServicePath="Services/regionService.asmx" ServiceMethod="Getregion" ParentControlID="DropDownListcountry" />
    <asp:Label ID="Label1" Text="&nbsp;&nbsp;&nbsp;&nbsp;Client:&nbsp;" runat="server"></asp:Label>
    <asp:DropDownList ID="DropDownListClient" runat="server" ToolTip="Select Client"
        AutoPostBack="true" OnSelectedIndexChanged="GetInvoiceDetails" Width="173px"
        Height="21px">
    </asp:DropDownList>
    <br />
    <br />
    <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">
        <asp:View ID="View1" runat="server">
            <asp:GridView ID="GridView1" HorizontalAlign="Center" runat="server" AutoGenerateColumns="False"
                AllowPaging="True" PageSize="15" OnPageIndexChanging="GridView1_PageIndexChanging"
                Width="85%" DataKeyNames="key" CssClass="mGrid" OnRowCommand="LoadDetails" EmptyDataText="No Data Currently"
                AlternatingRowStyle-CssClass="altRow">
                <Columns>
                    <asp:BoundField DataField="key" HeaderText="Invoice NO" ReadOnly="false" SortExpression="cpono" />
                    <asp:BoundField DataField="podate" HeaderText="Created DATE" ReadOnly="false" SortExpression="op_date"
                        DataFormatString="{0:MMM/dd/yyyy}" />
                    <asp:ButtonField ButtonType="Link" CommandName="Details" HeaderText="Print" Text="Print" />
                </Columns>
            </asp:GridView>
        </asp:View>
        <asp:View ID="View2" runat="server">
            <div class="DivTable">
                <div class="DivTableRow">
                    <div class="DivTable2firstcol">
                    </div>
                    <div class="DivTable2secondcol">
                        <asp:Button ID="btnPrint" runat="server" Text="Print Invoice" OnClientClick="print();" />
                        &nbsp;
                        <asp:Label ID="Message" runat="server"></asp:Label>
                    </div>
                </div>
                <br />
                <asp:Label ID="EntityIDhide" runat="server" Visible="false" Text="" Font-Bold="true"></asp:Label>
                <br />
                <div id="divPrint">
                    <div class="DivTable">
                        <div class="DivTableRow" align="left">
                            <div class="DivTable2ColHalf">
                                <asp:Label ID="LblCNameO" runat="server" Text="   鸿兴行" Font-Bold="True" Font-Size="36px" />
                                <br />
                                <asp:Label ID="LblENameO" runat="server" Text="HONG HING TRADING LTD" Font-Bold="True"
                                    Font-Size="18px">
                                </asp:Label>
                                <br />
                                <asp:Label ID="LblAddressO" runat="server" Text="Address:113-2631 Viking Way, Richmond, BC V6V 1N3"
                                    Font-Bold="True" Font-Size="10px">
                                </asp:Label>
                                <br />
                                <asp:Label ID="LblPhoneO" runat="server" Text="Tel:604-821-0780  Fax:604-821-0784  Cell:778-389-0780"
                                    Font-Bold="True" Font-Size="10px">
                                </asp:Label>
                            </div>
                            <div class="DivTable2ColHalf">
                                <div class="DivTable">
                                    <div class="DivTableRow100">
                                        <div class="DivTable1secondcol">
                                            &nbsp; &nbsp;</div>
                                        <div class="DivTable2secondcol">
                                        </div>
                                    </div>
                                    <div class="DivTableRow100">
                                        <div class="DivTable2ColHalf">
                                            <asp:Label ID="Label4" runat="server" Text="INVOICE DATE: " Font-Bold="True" Font-Size="Small"></asp:Label>
                                            <br />
                                            <asp:Label ID="Label5" runat="server" Text="发票日期: " Font-Bold="True" Font-Size="Small"></asp:Label>
                                        </div>
                                        <div class="DivTable2ColHalf">
                                            <asp:Label ID="Invoice_date" runat="server" Font-Bold="True" Font-Size="Small">
                                            </asp:Label>
                                        </div>
                                    </div>
                                    <div class="DivTableRow100">
                                        <div class="DivTable1secondcol">
                                        </div>
                                        <div class="DivTable2secondcol">
                                        </div>
                                    </div>
                                    <div class="DivTableRow100">
                                        <div class="DivTable2ColHalf">
                                            <asp:Label ID="receiptdocument" runat="server" Text="INVOICE NO: " Font-Bold="True"
                                                Font-Size="Small"></asp:Label>
                                            <br />
                                            <asp:Label ID="Label7" runat="server" Text="发票号码: " Font-Bold="True" Font-Size="Small"></asp:Label>
                                        </div>
                                        <div class="DivTable2ColHalf">
                                            <asp:Label ID="Invoice_no" runat="server" Font-Bold="True" Font-Size="Small">
                                            </asp:Label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <br />
                    <div class="pageSegment">
                        <div class="DivTableRow">
                            <div class="DivTable2firstcolErp">
                                <asp:Label ID="Label88" runat="server" Text="SOLD TO: " Font-Bold="True" Font-Size="Small"></asp:Label>
                                <br />
                                <asp:Label ID="Label99" runat="server" Text="买者: " Font-Bold="True" Font-Size="Small"></asp:Label>
                            </div>
                            <div class="DivTable2secondcolErp">
                                <asp:Label ID="LblCustomerName" runat="server" Text="Name " Font-Bold="True" Font-Size="Small"></asp:Label>
                                <br />
                                <asp:Label ID="LblCustomerAddress" runat="server" Text="Address" Font-Bold="True"
                                    Font-Size="Small"></asp:Label>
                            </div>
                        </div>
                    </div>
                    <wc:ReportGridView runat="server" BorderWidth="1" ID="gvSample" AutoGenerateColumns="false"
                        ShowFooter="True" OnRowDataBound="GridView1_RowDataBound" PrintPageSize="25"
                        AllowPrintPaging="true" Width="670px">
                        <Columns>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:Label ID="lblheader11" Text="CODE" Font-Bold="true" runat="server"></asp:Label>
                                    <br />
                                    <asp:Label ID="lblheader121" Text="货号" Font-Bold="true" runat="server"></asp:Label>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblpartno" runat="server" Text='<%# Eval("part_no").ToString()%>'>
                                    </asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:Label ID="lblheader1a" Text="QTY" Font-Bold="true" runat="server"></asp:Label>
                                    <br />
                                    <asp:Label ID="lblheader12a" Text="数量" Font-Bold="true" runat="server"></asp:Label>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblqtya" runat="server" Text='<%# Eval("qty").ToString()%>'>
                                    </asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:Label ID="lblunitheader1a" Text="UNIT" Font-Bold="true" runat="server"></asp:Label>
                                    <br />
                                    <asp:Label ID="lblunitheader12a" Text="单位" Font-Bold="true" runat="server"></asp:Label>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblunita" runat="server" Text='<%# Eval("unit").ToString()%>'>
                                    </asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:Label ID="lbldescheader1a" Text="DESCRIPTION" Font-Bold="true" runat="server"></asp:Label>
                                    <br />
                                    <asp:Label ID="lbldescheader12a" Text="摘要" Font-Bold="true" runat="server"></asp:Label>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lbldescta" runat="server" Text='<%# Eval("part_name").ToString()%>'>
                                    </asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:Label ID="lblunitheader1a" Text="UNIT PRICE" Font-Bold="true" runat="server"></asp:Label>
                                    <br />
                                    <asp:Label ID="lblunitheader12a" Text="单价" Font-Bold="true" runat="server"></asp:Label>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblunita" runat="server" Text='<%# Eval("uprice").ToString()%>'>
                                    </asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="CPONO">
                                <HeaderTemplate>
                                    <asp:Label ID="lblheader1" Text="CPONO" Font-Bold="true" runat="server"></asp:Label>
                                    <br />
                                    <asp:Label ID="lblheader12" Text="订单号" Font-Bold="true" runat="server"></asp:Label>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblAmountCPO" runat="server" Text='<%# Eval("cpono").ToString()%>'>
                                    </asp:Label>
                                </ItemTemplate>
                                <FooterTemplate>
                                    <div align="right">
                                        <asp:Label ID="lblTotalTCPO" Text="合共金额 SubTotal:" Font-Bold="true" runat="server"></asp:Label>
                                        <br />
                                        <br />
                                        <asp:Label ID="Label12" Text="总合计金额&nbsp;&nbsp;&nbsp; Total:" Font-Bold="true" runat="server"></asp:Label>
                                    </div>
                                </FooterTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="TAX">
                                <HeaderTemplate>
                                    <asp:Label ID="lblheader1" Text="TAX" Font-Bold="true" runat="server"></asp:Label>
                                    <br />
                                    <asp:Label ID="lblheader12" Text="税项" Font-Bold="true" runat="server"></asp:Label>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblAmountT" runat="server" Text='<%# "$"+Eval("tax").ToString()%>'>
                                    </asp:Label>
                                </ItemTemplate>
                                <FooterTemplate>
                                    <asp:Label ID="lblTotalT" runat="server"></asp:Label>
                                    <br />
                                    <br />
                                    <asp:Label ID="Label112" runat="server" Text="-"></asp:Label>
                                </FooterTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="AMOUNT">
                                <HeaderTemplate>
                                    <asp:Label ID="lblheader1" Text="AMOUNT" Font-Bold="true" runat="server"></asp:Label>
                                    <br />
                                    <asp:Label ID="lblheader12" Text="金额" Font-Bold="true" runat="server"></asp:Label>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblAmount" runat="server" Text='<%# "$"+Eval("paidprice").ToString()%>'>
                                    </asp:Label>
                                </ItemTemplate>
                                <FooterTemplate>
                                    <asp:Label ID="lblTotal" runat="server"></asp:Label>
                                    <br />
                                    <br />
                                    <asp:Label ID="lblTotalAll" runat="server"></asp:Label>
                                </FooterTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <PageHeaderTemplate>
                            <br />
                            <div class="DivTable">
                                <div class="DivTableRowLeft">
                                    <asp:Label ID="receiptdocument" runat="server" Text="鸿兴行" Font-Bold="True" Font-Size="36px" />
                                    <br />
                                    <asp:Label ID="CPO_no" runat="server" Text="HONG HING TRADING LTD" Font-Bold="True"
                                        Font-Size="18px">
                                    </asp:Label>
                                    <br />
                                    <asp:Label ID="Label6" runat="server" Text="Address:113-2631 Viking Way, Richmond, BC V6V 1N3"
                                        Font-Bold="True" Font-Size="10px">
                                    </asp:Label>
                                    <br />
                                    <asp:Label ID="Label7" runat="server" Text="Tel:604-821-0780  Fax:604-821-0784  Cell:778-389-0780"
                                        Font-Bold="True" Font-Size="10px">
                                    </asp:Label>
                                </div>
                            </div>
                            <br />
                        </PageHeaderTemplate>
                        <PageFooterTemplate>
                            <div class="DivTable" align="right">
                                Page
                                <%# gvSample.CurrentPrintPage.ToString() %>
                                /
                                <%# gvSample.PrintPageCount %>
                            </div>
                        </PageFooterTemplate>
                    </wc:ReportGridView>
                    <br />
                    <asp:Label ID="Label81" runat="server" Text="尊敬的客户： 货品如有差错，请在5天内通知本行，多谢合作！" Font-Bold="True"
                        Font-Size="10px">
                    </asp:Label>
                    <br />
                    <asp:Label ID="Label91" runat="server" Text="谨祝：阁下生意兴隆！" Font-Bold="True" Font-Size="10px">
                    </asp:Label>
                    <br />
                    <br />
                    <asp:Label ID="Label10" runat="server" Text="Goods Received by 收货人： " Font-Bold="True"
                        Font-Size="12px">
                    </asp:Label>
                    <br />
                    <br />
                    <asp:Label ID="Label11" runat="server" Text="DATE 日期： " Font-Bold="True" Font-Size="12px">
                    </asp:Label>
                    <%--<asp:GridView ID="GridView2" AutoGenerateColumns="false" DataKeyNames="id_num" runat="server"
                        HorizontalAlign="Center" Width="85%">
                        <Columns>
                            <asp:BoundField DataField="itemno" HeaderText="SN#" SortExpression="itemno" />
                            <asp:BoundField DataField="part_no" HeaderText="PART#" ReadOnly="false" SortExpression="part_no" />
                            <asp:BoundField DataField="qty" HeaderText="QTY" ReadOnly="true" />
                            <asp:BoundField DataField="cname" HeaderText="Customer" ReadOnly="false" />
                            <asp:BoundField DataField="cpono" HeaderText="CPONO" ReadOnly="false" />
                        </Columns>
                    </asp:GridView>--%>
                </div>
                <div class="DivTableRow">
                    <asp:LinkButton ID="LinkButton1" Text="Back to Previous Page" OnClick="BacktoPreviousPage"
                        CssClass="LinkButtonStyle" runat="server" CausesValidation="False"></asp:LinkButton>
                </div>
            </div>
        </asp:View>
    </asp:MultiView>
</asp:Content>
