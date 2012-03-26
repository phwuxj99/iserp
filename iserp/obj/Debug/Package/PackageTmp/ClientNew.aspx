<%@ Page Title="" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true"
    EnableEventValidation="false" CodeBehind="ClientNew.aspx.cs" Inherits="iserp.ClientNew" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function change_focus_t1(obj, next) {
            if (obj.value.length == obj.maxLength) {
                //document.getElementById("ctl00_ ContentPlaceHolderBom_tel11").value = obj.value;
                //document.getElementById("ctl00_ ContentPlaceHolderBom_tel11").value = obj.value;
                //aa.value = obj.value;
                next.focus();
            }
        }
        function change_focus_t2(obj, next) {
            if (obj.value.length == obj.maxLength) {
                //document.getElementById("ctl00_ ContentPlaceHolderBom_tel21").value = obj.value;
                next.focus();
            }
        }
        function change_focus_t3(obj, next) {
            if (obj.value.length == obj.maxLength) {
                //document.getElementById("ctl00_ ContentPlaceHolderBom_tel31").value = obj.value;
                next.focus();
            }
        }
        function change_focus_t4(obj, next) {
            //if (obj.value.length == obj.maxLength) {
            document.getElementById("tel41").value = obj.value;
            //     next.focus();
            // }
        }

        function change_focus_f1(obj, next) {
            if (obj.value.length == obj.maxLength) {
                //document.getElementById("ctl00_ ContentPlaceHolderBom_fax11").value = obj.value;
                next.focus();
            }
        }
        function change_focus_f2(obj, next) {
            if (obj.value.length == obj.maxLength) {
                //document.getElementById("ctl00_ ContentPlaceHolderBom_fax21").value = obj.value;
                next.focus();
            }
        }
        function change_focus_f3(obj, next) {
            //if (obj.value.length == obj.maxLength) {
            document.getElementById("ctl00_ ContentPlaceHolderBom_fax31").value = obj.value;
            //     next.focus();
            // }
        }
    </script>
    <p align="center" class="green">
        <font color="#0000ff" size="4">Add New Customer</font>
    </p>
    <div style="text-align: center">
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" HeaderText="You must enter a value in the following fields"
            DisplayMode="List" />
        <br />
        <div class="DivTable">
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <font color="#000000"><b>&nbsp;Client Name</b></font>:
                </div>
                <div class="DivTable2secondcol">
                    <asp:TextBox ID="cname" runat="server" Width="322px"></asp:TextBox>&nbsp;
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="cname"
                        ErrorMessage="Client Name is not allow empty">*</asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <font color="#000000"><b>&nbsp;Client Code</b></font>:
                </div>
                <div class="DivTable2secondcol">
                    <asp:TextBox ID="client_code" runat="server" Width="60px"></asp:TextBox>&nbsp;
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="client_code"
                        ErrorMessage="Client Code is not allow empty">*</asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <strong><font face="Verdana" color="#000000" size="1">Contact Person </font></strong>
                    :
                </div>
                <div class="DivTable2secondcol">
                    <asp:TextBox ID="cperson" runat="server" Width="183px"></asp:TextBox>
                    &nbsp;
                </div>
            </div>
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <font color="#000000"><b><font face="Verdana" size="1">Contact Phone </font></b>
                    </font>:
                </div>
                <div class="DivTable2secondcol">
                    <input id="tel1" onkeyup="change_focus_t1(this,tel2)" maxlength="3" style="width: 35px"
                        name="tel1" type="text" />
                    -&nbsp;&nbsp;
                    <input id="tel2" onkeyup="change_focus_t2(this,tel3)" maxlength="3" style="width: 35px"
                        name="tel2" type="text" />
                    -&nbsp;&nbsp;
                    <input id="tel3" onkeyup="change_focus_t3(this,tel4)" maxlength="4" style="width: 35px"
                        name="tel3" type="text" />
                    Ext.
                    <input id="tel4" maxlength="7" style="width: 35px" type="text" name="tel4" />
                </div>
            </div>
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <strong><font face="Verdana" color="#000000" size="1">Fax </font></strong>:
                </div>
                <div class="DivTable2secondcol">
                    <font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                        <input id="fax1" onkeyup="change_focus_f1(this,fax2)" style="width: 35px" maxlength="3"
                            name="fax1" type="text" />
                        -&nbsp;
                        <input id="fax2" onkeyup="change_focus_f2(this,fax3)" style="width: 35px" maxlength="3"
                            name="fax2" type="text" />
                        -&nbsp;
                        <input id="fax3" maxlength="4" name="fax3" type="text" style="width: 35px" />
                    </font>
                </div>
            </div>
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Address </font>
                    </strong>:
                </div>
                <div class="DivTable2secondcol">
                    <textarea id="saddress" runat="server" cols="44" rows="2" style="width: 398px" name="S1"></textarea>
                </div>
            </div>
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <strong><font face="Verdana" size="1">City :</font></strong>
                </div>
                <div class="DivTable2secondcol">
                    <asp:TextBox ID="scity" runat="server" Width="180px"></asp:TextBox>
                </div>
            </div>
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <strong><font face="Verdana" color="#000000" size="1">Country :</font></strong>
                </div>
                <div class="DivTable2secondcol">
                    <asp:DropDownList ID="DropDownListcountry" runat="server" Width="146px" Height="19px">
                    </asp:DropDownList>
                    <ajaxToolkit:CascadingDropDown ID="CascadingDropDown1" runat="server" TargetControlID="DropDownListcountry"
                        Category="country" PromptText="Please select a country" LoadingText="[Loading Country...]"
                        ServicePath="Services/regionService.asmx" ServiceMethod="Getcountry" />
                </div>
            </div>
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <strong><font face="Verdana" color="#000000" size="1">Region :</font></strong>
                </div>
                <div class="DivTable2secondcol">
                    <asp:DropDownList ID="DropDownListregion" runat="server" Width="173px" Height="21px">
                    </asp:DropDownList>
                    <ajaxToolkit:CascadingDropDown ID="CascadingDropDown2" runat="server" TargetControlID="DropDownListregion"
                        Category="region" PromptText="Please select a region" LoadingText="[Loading Region...]"
                        ServicePath="Services/regionService.asmx" ServiceMethod="Getregion" ParentControlID="DropDownListcountry" />
                </div>
            </div>
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <font color="#000000"><b><font face="Verdana" size="1">Post Code :</font></b></font>
                </div>
                <div class="DivTable2secondcol">
                    <asp:TextBox ID="post_code" runat="server" Width="180px"></asp:TextBox>
                </div>
            </div>
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <strong><font face="Verdana" size="1">E-Mail Address </font></strong>:
                </div>
                <div class="DivTable2secondcol">
                    <asp:TextBox ID="email" runat="server" Width="286px"></asp:TextBox>
                </div>
            </div>
            
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <strong><font face="Verdana" size="1">TAX(%) </font></strong>:
                </div>
                <div class="DivTable2secondcol">
                    <asp:TextBox ID="invoice_tax" runat="server" Width="286px"></asp:TextBox>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="invoice_tax"
                                    ErrorMessage="Error: Please input valid tax" ValidationExpression="[0-9]+">*</asp:RegularExpressionValidator>
                                <ajaxToolkit:ValidatorCalloutExtender ID="ValidatorCalloutExtender1" runat="server"
                                    TargetControlID="RegularExpressionValidator2" HighlightCssClass="validatorCalloutHighlight">
                                </ajaxToolkit:ValidatorCalloutExtender>
                </div>
            </div>
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                    <font color="#000000"><b><font face="Verdana" size="1">&nbsp;Web Page :</font></b></font>
                </div>
                <div class="DivTable2secondcol">
                    <asp:TextBox ID="website" runat="server" Width="286px"></asp:TextBox>
                </div>
            </div>
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                    Note :
                </div>
                <div class="DivTable2secondcol">
                    <textarea id="notes" runat="server" cols="44" style="width: 398px; height: 64px;"
                        name="S2" rows="15"></textarea>
                </div>
            </div>
            <div class="DivTableRow">
                <div class="DivTable2firstcol">
                </div>
                <div class="DivTable2secondcol">
                    <asp:Button runat="server" Text="Confirm" SkinID="ASPButton" ID="LogButton" OnClick="AddAuthor_Click"
                        Width="97px" />&nbsp;&nbsp;&nbsp;
                         <asp:Label ID="Message" CssClass="LabelErrorMsg" runat="server"></asp:Label>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
