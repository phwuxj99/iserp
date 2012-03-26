<%@ Page Title="" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true"
    CodeBehind="PartnoSearch.aspx.cs" Inherits="iserp.PartnoSearch" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="Styles/ui-lightness/jquery-ui-1.8.14.custom.css" rel="stylesheet" type="text/css" />
    <script src="Scripts/ui/jquery-ui-1.8.14.js" type="text/javascript"></script>
    <script src="Scripts/ui/jquery.ui.core.js" type="text/javascript"></script>
    <script src="Scripts/ui/jquery.ui.widget.js" type="text/javascript"></script>
    <script src="Scripts/ui/jquery.ui.position.js" type="text/javascript"></script>
    <script src="Scripts/ui/jquery.ui.autocomplete.js" type="text/javascript"></script>
    <script src="Scripts/Autocomplete.js" type="text/javascript"></script>
    <%-- <script src="Scripts/Autocomplete.js" type="text/javascript"></script>--%>
    <%--<link href="Styles/jquery-ui-1.8.5.custom.css" rel="stylesheet" type="text/css" />
    
    <script type="text/javascript" src="Scripts/jquery-1.4.2.min.js"></script>
    <script type="text/javascript" src="Scripts/jquery-ui-1.8.5.custom.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#txbSearchKeyword").autocomplete({
                minLength: 2,
                source: function (term, data) {
                    $.ajax({
                        type: "GET",
                        contentType: "application/json; charset=utf-8",
                        url: "services/AutoComplete.svc/GetAllWords",
                        data: { "term": term.term },
                        dataType: "json",
                        success: function (response) {
                            data(response.d);
                        }
                    });
                }
            });
        }); 
    </script>--%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <br />
    <asp:Label ID="ErrorBox" runat="server" CssClass="LabelErrorMsg">    </asp:Label>
    <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">
        <asp:View ID="View1" runat="server">
            <div class="ui-widget">
                <asp:Label ID="lblSearch" Text="Part# Search" AssociatedControlID="txbSearchKeyword"
                    runat="server"></asp:Label>
                <asp:TextBox ID="txbSearchKeyword" runat="server" CssClass="searchinput"></asp:TextBox>
                <%--<ajaxToolkit:AutoCompleteExtender
                runat="server" 
                BehaviorID="AutoCompleteEx"
                ID="autoComplete1" 
                TargetControlID="txbSearchKeyword"
                ServicePath="services/ServiceAjaxEnable.svc" 
                ServiceMethod="GetAllPredictions"
                MinimumPrefixLength="2" 
                CompletionInterval="1000"
                EnableCaching="true">
            </ajaxToolkit:AutoCompleteExtender>--%>
                <asp:Button ID="Button1" Text="Go!" runat="server" OnClick="Search_Click" />
            </div>
            <br />
            <asp:GridView ID="GridView1" HorizontalAlign="Center" runat="server" AutoGenerateColumns="False"
                AllowPaging="True" PageSize="25" OnPageIndexChanging="GridView1_PageIndexChanging"
                Width="85%" DataKeyNames="part_no" CssClass="mGrid" OnRowCommand="LoadDetails"
                EmptyDataText="No Data Currently" AlternatingRowStyle-CssClass="altRow">
                <Columns>
                    <asp:BoundField DataField="part_no" HeaderText="Product NO" />
                    <asp:BoundField DataField="part_name" HeaderText="Product Name" />
                    <asp:BoundField DataField="unit" HeaderText="Unit" />
                    <%--<asp:BoundField DataField="category" HeaderText="Category" />--%>
                    <asp:BoundField DataField="price1" HeaderText="Sale Price" />
                    <asp:BoundField DataField="price2" HeaderText="Cost Price" />
                    <asp:ButtonField ButtonType="Link" CommandName="Details" HeaderText="Details" Text="Details" />
                </Columns>
            </asp:GridView>
            <br />
        </asp:View>
        <asp:View ID="View2" runat="server">
            <asp:Label ID="EntityIDhide" runat="server" Visible="false" Text="" Font-Bold="true"></asp:Label>
            <br />
            <asp:FormView ID="FormView1" DataKeyNames="part_no" runat="server" OnItemUpdating="FormView1_ItemUpdating"
                OnModeChanging="FormView1_ModeChanging" CssClass="FormViewStyle FormViewWidth" OnDataBound="fv_DataBound"
                HorizontalAlign="Center" OnItemInserting="FormView1_Inserting" OnModeChanged="FormView1_ModeChanged"
                OnItemCommand="FormView1_ItemCommand">
                <ItemTemplate>
                    <div class="DivTable">
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="Label1" runat="server" Text="Product No.:"></asp:Label>&nbsp;&nbsp;
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="Label6" runat="server" Text='<%# Bind("part_no") %>'></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="Label2" runat="server" Text="Product Name:"></asp:Label>&nbsp;&nbsp;
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="Label7" runat="server" Text='<%# Bind("part_name") %>'></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="Label3" runat="server" Text="Product Description:"></asp:Label>&nbsp;&nbsp;
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="Label11" runat="server" Text='<%# Bind("part_description") %>'></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="Label4" runat="server" Text="Unit:"></asp:Label>&nbsp;&nbsp;
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="Label12" runat="server" Text='<%# Bind("unit") %>'></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="Label5" runat="server" Text="Category:"></asp:Label>&nbsp;&nbsp;
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="lblCategory" runat="server" ></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="Label8" runat="server" Text="Sales Price($):"></asp:Label>&nbsp;&nbsp;
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="Label14" runat="server" Text='<%# Bind("price1") %>'></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="Label13" runat="server" Text="Cost Price($):"></asp:Label>&nbsp;&nbsp;
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="Label17" runat="server" Text='<%# Bind("price2") %>'></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="Label9" runat="server" Text="Weight:"></asp:Label>&nbsp;&nbsp;
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="Label15" runat="server" Text='<%# Bind("weight") %>'></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="Label10" runat="server" Text="Note:"></asp:Label>&nbsp;&nbsp;
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:Label ID="Label16" runat="server" Text='<%# Bind("notes") %>'></asp:Label>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                            </div>
                            <div class="Div2Cols DivLeftSpace ">
                                <asp:LinkButton ID="lbEdit" Text="Edit" CommandName="Edit" runat="server" />
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <%--<asp:LinkButton ID="LbNew" Text="New" CommandName="New" runat="server" />--%>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
                <EditItemTemplate>
                    <div class="DivTable">
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="Label1" runat="server" Text="Product No.:"></asp:Label>&nbsp;&nbsp;
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:TextBox ID="part_no" runat="server" ReadOnly="true" Text='<%# Bind("part_no") %>'
                                    Width="225px" Enabled="False"></asp:TextBox>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="Label2" runat="server" Text="Product Name:"></asp:Label>&nbsp;&nbsp;
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:TextBox ID="part_name" runat="server" Text='<%# Bind("part_name") %>' Width="225px"></asp:TextBox>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="Label3" runat="server" Text="Product Description:"></asp:Label>&nbsp;&nbsp;
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:TextBox ID="part_description" runat="server" Text='<%# Bind("part_description") %>'
                                    TextMode="MultiLine" Width="125px"></asp:TextBox>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="Label4" runat="server" Text="Unit:"></asp:Label>&nbsp;&nbsp;
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:TextBox ID="unit" runat="server" Text='<%# Bind("unit") %>' Width="125px"></asp:TextBox>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="Label5" runat="server" Text="Category:"></asp:Label>&nbsp;&nbsp;
                            </div>
                            <div class="DivTable2secondcol">
                                <%--<asp:TextBox ID="category" runat="server" Text='<%# Bind("category") %>' Width="125px"></asp:TextBox>--%>
                                <asp:DropDownList ID="ddlCategory" runat="server"   />
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="Label8" runat="server" Text="Sales Price($):"></asp:Label>&nbsp;&nbsp;
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:TextBox ID="price1" runat="server" Text='<%# Bind("price1") %>' Width="125px"></asp:TextBox>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="Label18" runat="server" Text="Cost Price($):"></asp:Label>&nbsp;&nbsp;
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:TextBox ID="price2" runat="server" Text='<%# Bind("price2") %>' Width="125px"></asp:TextBox>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="Label9" runat="server" Text="Weight:"></asp:Label>&nbsp;&nbsp;
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:TextBox ID="weight" runat="server" Text='<%# Bind("weight") %>' Width="125px">0</asp:TextBox>(LB)
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="weight"
                                    ErrorMessage="Weight: Please input valid Number" ValidationExpression="^[-+]?[0-9]\d{0,2}(\.\d{1,3})?%?$">*</asp:RegularExpressionValidator>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                                <asp:Label ID="Label10" runat="server" Text="Note:"></asp:Label>&nbsp;&nbsp;
                            </div>
                            <div class="DivTable2secondcol">
                                <asp:TextBox ID="notes" runat="server" Text='<%# Bind("notes") %>' TextMode="MultiLine"
                                    Width="125px"></asp:TextBox>
                            </div>
                        </div>
                        <div class="DivTableRow">
                            <div class="DivTable2firstcol">
                            </div>
                            <div class="Div2Cols DivLeftSpace ">
                                <asp:LinkButton ID="UpdateButton" Text="Update" CommandName="Update" runat="server" />
                                &nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="CancelButton" Text="Cancel" CommandName="Cancel" runat="server"
                                    CausesValidation="False" />
                            </div>
                        </div>
                    </div>
                </EditItemTemplate>
            </asp:FormView>
            <div align="center">
                <asp:LinkButton ID="LinkButton1" Text="Back to Previous Page" OnClick="BacktoPreviousPage"
                    CssClass="LinkButtonStyle" runat="server" CausesValidation="False"></asp:LinkButton>
            </div>
        </asp:View>
    </asp:MultiView>
</asp:Content>
