<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminUserProfile.aspx.cs" Inherits="iserp.AdminUserProfile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
 <p align="center" class="green">
        <font color="#0000ff" size="4">Users Profile</font>
    </p>
            <div class="DivTable">
                <div class="DivTableRow">
                    <div class="DivTable2firstcol">
                        <asp:Label ID="LblID" runat="server" CssClass="Regtxt" Text="ID" Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="lblLoginName" runat="server" CssClass="Regtxt" Text="Name"></asp:Label>
                        &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" /></div>
                    <div class="DivTable2secondcol">
                        <asp:TextBox ID="txtLoginName" runat="server" Enabled="False" ReadOnly="True"></asp:TextBox>
                    </div>
                </div>
                <div class="DivTableRow">
                    <div class="DivTable2firstcol">
                        <asp:Label ID="lblFullName" runat="server" CssClass="Regtxt" Text="User ID"> </asp:Label>
                        &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" />
                    </div>
                    <div class="DivTable2secondcol">
                        <asp:TextBox ID="txtUserID" runat="server" Style="margin-left: 0px" 
                            Width="225px" Enabled="False" ReadOnly="True"></asp:TextBox></div>
                </div>
                <div class="DivTableRow">
                    <div class="DivTable2firstcol">
                        <asp:Label ID="lblEmail" runat="server" CssClass="Regtxt" Text="Email"> </asp:Label>
                        &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" /></div>
                    <div class="DivTable2secondcol">
                        <asp:TextBox ID="txtEmail" runat="server" Width="225px"></asp:TextBox>
                    </div>
                </div>
                <div class="DivTableRow">
                    <div class="DivTable2firstcol">
                        <asp:Label ID="lblCountry" runat="server" CssClass="Regtxt" Text="Country & Region"> </asp:Label>
                        &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" />
                    </div>
                    <div class="DivTable2secondcol">
                        <asp:DropDownList ID="DropDownListcountry" runat="server" Width="146px" Height="19px">
                        </asp:DropDownList>
                        <ajaxtoolkit:cascadingdropdown id="CascadingDropDown1" runat="server" targetcontrolid="DropDownListcountry"
                            category="country" prompttext="Please select a country" loadingtext="[Loading Country...]"
                            servicepath="~/services/regionService.asmx" servicemethod="Getcountry" />
                        &nbsp; -- &nbsp;
                        <asp:DropDownList ID="DropDownListregion" runat="server" Width="173px" Height="21px">
                        </asp:DropDownList>
                        <ajaxtoolkit:cascadingdropdown id="CascadingDropDown2" runat="server" targetcontrolid="DropDownListregion"
                            category="region" prompttext="Please select a region" loadingtext="[Loading Region...]"
                            servicepath="~/services/regionService.asmx" servicemethod="Getregion" parentcontrolid="DropDownListcountry" />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="DropDownListregion">* </asp:RequiredFieldValidator>
                        <ajaxtoolkit:validatorcalloutextender id="ValidatorCalloutExtender6" runat="server"
                            highlightcssclass="ErrorStyle" targetcontrolid="RequiredFieldValidator5">
                        </ajaxtoolkit:validatorcalloutextender>
                    </div>
                </div>
                <div class="DivTableRow">
                    <div class="DivTable2firstcol">
                        &nbsp;&nbsp;
                        <asp:Label ID="lblCity" runat="server" CssClass="Regtxt" Text="City"></asp:Label>
                        &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" />
                    </div>
                    <div class="DivTable2secondcol">
                        <asp:TextBox ID="txtCity" runat="server" Width="225px"></asp:TextBox>
                    </div>
                </div>
                <div class="DivTableRow">
                    <div class="DivTable2firstcol">
                        &nbsp;&nbsp;
                        <asp:Label ID="lblCompanyName" runat="server" CssClass="Regtxt" Text="CompanyName"></asp:Label>
                        &nbsp;<img height="8" src="image/mandatory.gif" alt="" width="8" />
                    </div>
                    <div class="DivTable2secondcol">
                        <asp:TextBox ID="txtCompanyName" runat="server" Width="225px"></asp:TextBox>
                    </div>
                </div>
                <div class="DivTableRow">
                    <div class="DivTable2firstcol">
                        &nbsp;<asp:Label ID="lblPhone" runat="server" CssClass="Regtxt" Text="Phone"></asp:Label>
                        &nbsp;<img height="25" src="image/01_telephone_inv_thumb.gif" width="25" alt="" /></div>
                    <div class="DivTable2secondcol">
                        <asp:TextBox ID="txtCompanyPhone" runat="server" Width="225px"></asp:TextBox>
                    </div>
                </div>
                <div class="DivTableRow">
                    <div class="DivTable2firstcol">
                        <asp:Label ID="Label1" runat="server" CssClass="Regtxt" Text=""></asp:Label>
                        &nbsp;
                        <img height="25" src="image/51_rightarrow_inv_thumb.gif" alt="" width="25" />
                    </div>
                    <div class="DivTable2secondcol">
                        <asp:Button ID="btnRegister" runat="server" Text="Confirm" OnClick="btnRegister_Click">
                        </asp:Button>
                        <asp:Label ID="Message" runat="server" ForeColor="#FF3300"></asp:Label>
                    </div>
                </div>
                
            </div></asp:Content>
