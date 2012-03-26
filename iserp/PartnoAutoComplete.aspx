<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PartnoAutoComplete.aspx.cs" Inherits="iserp.PartnoAutoComplete" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
 <link href="css/StyleSheet.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<%--<asp:TextBox ID="myTextBox" runat="server" CssClass="searchinput"></asp:TextBox>--%>

    <div class="demoarea">
        <div class="demoheading">AutoComplete Demonstration</div>
            Type some characters in this textbox.  The web service returns random words
            that start with the text you have typed.
            <br /><br />
            <asp:TextBox runat="server" ID="myTextBox" Width="300" autocomplete="off" />
            <ajaxToolkit:AutoCompleteExtender
                runat="server" 
                BehaviorID="AutoCompleteEx"
                ID="autoComplete1" 
                TargetControlID="myTextBox"
                ServicePath="Services/PartnoWebService.asmx" 
                ServiceMethod="GetCompletionList"
                MinimumPrefixLength="2" 
                CompletionInterval="1000"
                EnableCaching="true"
                CompletionSetCount="20"
                CompletionListCssClass="autocomplete_completionListElement" 
                CompletionListItemCssClass="autocomplete_listItem" 
                CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                ShowOnlyCurrentWordInCompletionListItem="true" >
                <Animations>
                    <OnShow>
                        <Sequence>
                            <%-- Make the completion list transparent and then show it --%>
                            <OpacityAction Opacity="0" />
                            <HideAction Visible="true" />
                            
                            <%--Cache the original size of the completion list the first time
                                the animation is played and then set it to zero --%>
                            <ScriptAction Script="
                                // Cache the size and setup the initial size
                                var behavior = $find('AutoCompleteEx');
                                if (!behavior._height) {
                                    var target = behavior.get_completionList();
                                    behavior._height = target.offsetHeight - 2;
                                    target.style.height = '0px';
                                }" />
                            
                            <%-- Expand from 0px to the appropriate size while fading in --%>
                            <Parallel Duration=".4">
                                <FadeIn />
                                <Length PropertyKey="height" StartValue="0" EndValueScript="$find('AutoCompleteEx')._height" />
                            </Parallel>
                        </Sequence>
                    </OnShow>
                    <OnHide>
                        <%-- Collapse down to 0px and fade out --%>
                        <Parallel Duration=".4">
                            <FadeOut />
                            <Length PropertyKey="height" StartValueScript="$find('AutoCompleteEx')._height" EndValue="0" />
                        </Parallel>
                    </OnHide>
                </Animations>
            </ajaxToolkit:AutoCompleteExtender>

            <script type="text/javascript">
                // Work around browser behavior of "auto-submitting" simple forms
                var frm = document.getElementById("aspnetForm");
                if (frm) {
                    frm.onsubmit = function () { return false; };
                }
            </script>
            <%-- Prevent enter in textbox from causing the collapsible panel from operating --%>
            <input type="submit" style="display:none;" />
    </div>
    <div class="demobottom"></div>
</asp:Content>
