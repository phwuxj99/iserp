<%@ Page Title="" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true"
    EnableEventValidation="false" CodeBehind="CpoAdd.aspx.cs" Inherits="iserp.CpoAdd" %>

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
    <p align="center" class="green">
        <font color="#0000ff" size="4">Add New CPO </font>
    </p>
    <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">
        <asp:View ID="view1" runat="server">
            <div style="width: 100%; text-align: center">
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
                <br />
                <br />
                <div class="DivTable">
                    <div class="DivTableRow">
                        <div class="DivTable2firstcol">
                            <asp:Label ID="Label1" Text="&nbsp;&nbsp;&nbsp;&nbsp;Client:&nbsp;" runat="server"></asp:Label>
                        </div>
                        <div class="DivTable2secondcol">
                            <asp:DropDownList ID="DropDownListClient" runat="server" ToolTip="Select Client"
                                Width="173px" Height="21px">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="DivTableRow">
                        <div class="DivTable2firstcol">
                            &nbsp;C.P.NO:&nbsp;</div>
                        <div class="DivTable2secondcol">
                            <asp:TextBox ID="txbcpono" runat="server" Width="85px"></asp:TextBox>
                            <asp:Label ID="Label4" runat="server" Text="(For example: 20120001)" Font-Bold="True"
                                Font-Size="Small"></asp:Label>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txbcpono"
                                ErrorMessage="Please Input the receipt NO." ValidationGroup="abc">*</asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="DivTableRow">
                        <div class="DivTable2firstcol">
                        </div>
                        <div class="DivTable2secondcol">
                            &nbsp;
                            <asp:Button ID="Button1" Text="Confirm" SkinID="ASPButton" OnClick="Button1_Click"
                                ValidationGroup="abc" runat="Server" Width="65px" />&nbsp; &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </asp:View>
        <asp:View ID="view2" runat="server">
            <asp:Label ID="CPOdocument" runat="server" Text="CPO NO:" Font-Bold="True" Font-Size="Small"></asp:Label>
            &nbsp;
            <asp:Label ID="cpo_no" runat="server" Font-Bold="True" Font-Size="Small"></asp:Label>
            &nbsp;
            <asp:Label ID="lblCpoCustomer" runat="server" Font-Bold="True" Font-Size="Small"></asp:Label>:&nbsp;
            <asp:Label ID="lblCpoCustomerID" runat="server" Font-Bold="True" Font-Size="Small"></asp:Label>
            <div class="DivTable">
                <div class="DivTableRow">
                    <div class="DivTable2firstcol">
                        <asp:Label ID="Label5" Text="Part NO" runat="server"></asp:Label>
                    </div>
                    <div class="DivTable2secondcol">
                        <asp:TextBox ID="txbSearchKeyword" runat="server" CssClass="searchinput"></asp:TextBox>
                        <asp:Button ID="Button2" Text="Search" runat="server" OnClick="Search_Click" />
                    </div>
                </div>
                <div class="DivTableRow">
                    <div class="DivTable2firstcol">
                        <asp:Label ID="LblPartNo" Text="" runat="server"></asp:Label>
                    </div>
                    <div class="DivTable2secondcol">
                        &nbsp;<asp:Label ID="LblName" Text="" runat="server"></asp:Label>
                        &nbsp;&nbsp;&nbsp;
                        <asp:Label ID="Label10" Text="PRICE: " runat="server"></asp:Label>
                        <asp:Label ID="LblPrice" Text="" runat="server"></asp:Label>
                        &nbsp;&nbsp;&nbsp;
                        <asp:Label ID="Label9" Text="STOCK QTY: " runat="server"></asp:Label>
                        <asp:Label ID="LblInv" Text="" runat="server"></asp:Label>
                    </div>
                </div>
                <div class="DivTableRow">
                    <div class="DivTable2firstcol">
                        <asp:Label ID="Label6" Text="Quantity: " runat="server"></asp:Label>
                    </div>
                    <div class="DivTable2secondcol">
                        <asp:TextBox ID="txbQty" runat="server" CssClass="searchinput"></asp:TextBox>
                    </div>
                </div>
                <div class="DivTableRow">
                    <div class="DivTable2firstcol">
                        <asp:Label ID="Label7" Text="Price" runat="server"></asp:Label>
                    </div>
                    <div class="DivTable2secondcol">
                        <asp:TextBox ID="txbPrice" runat="server" CssClass="searchinput"></asp:TextBox>
                    </div>
                </div>
                <div class="DivTableRow">
                    <div class="DivTable2firstcol">
                    </div>
                    <div class="DivTable2secondcol">
                        <asp:Button ID="ButtonAddCpo" Text="Confirm" SkinID="ASPButton" OnClick="ButtonAddCpo_Click"
                            runat="Server" Width="65px" />
                        &nbsp;
                        <asp:Label ID="Message" runat="server" CssClass="LabelErrorMsg"></asp:Label>
                    </div>
                </div>
            </div>
            <asp:GridView ID="GridView1" runat="server" AllowPaging="true" DataKeyNames="id_num"
                OnRowDataBound="GridView1_RowDataBound" AutoGenerateDeleteButton="true" OnRowDeleting="GridView1_OnRowDeleting"
                PageSize="25" OnPageIndexChanging="GridView1_PageIndexChanging" SkinID="SampleGridView"
                EmptyDataText="No Data Currently" Width="85%" AutoGenerateColumns="False">
                <Columns>
                    <asp:BoundField DataField="itemno" HeaderText="SN#" />
                    <asp:BoundField DataField="part_no" HeaderText="PART#" ReadOnly="false" />
                    <asp:BoundField DataField="qty" HeaderText="QTY" ReadOnly="true" />
                    <asp:BoundField DataField="soprice" HeaderText="Price" ReadOnly="true" />
                    <asp:BoundField DataField="cpono" HeaderText="CPONO" ReadOnly="false" />
                </Columns>
            </asp:GridView>
            <br />
            <div class="DivTable">
                <div class="DivTableRow">
                    <asp:Button ID="Button3" Text="ADD CPO TO INVOICE" SkinID="ASPButton" OnClick="ButtonAddINV_Click"
                        runat="Server" Width="165px" Visible="False" />
                </div>
            </div>
        </asp:View>
    </asp:MultiView>
</asp:Content>
