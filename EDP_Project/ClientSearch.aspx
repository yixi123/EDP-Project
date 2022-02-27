<%@ Page Title="" Language="C#" MasterPageFile="~/Client.Master" AutoEventWireup="true" CodeBehind="ClientSearch.aspx.cs" Inherits="EDP_Project.ClientSearch" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        
.myAutoComplete{
    cursor:pointer;
    box-shadow:10px 10px grey;
    background-color:white;
}
.myAutoComplete:hover {
    background-color:lightgray;
}
.autocomplete {
          
    position: relative;
    display: inline-block;
}
.autocomplete-items {
    position: absolute;
    border: 1px solid #d4d4d4;
    border-bottom: none;
    border-top: none;
    z-index: 99;
    max-height:300px;
    overflow-y:auto;
    top: 100%;
    left: 0;
    right: 0;
}
.autocomplete-items div {
    padding: 10px;
    cursor: pointer;
    background-color: #fff;
    border-bottom: 1px solid #d4d4d4;
}
.autocomplete-items div:hover {
    /*when hovering an item:*/
    background-color: #e9e9e9;
}
.autocomplete-active {
    /*when navigating through the items using the arrow keys:*/
    background-color: DodgerBlue !important;
    color: #ffffff;
}
    </style>

    <script>
        
        function autocomplete(inp, arr) {
            /*the autocomplete function takes two arguments,
            the text field element and an array of possible autocompleted values:*/
            var currentFocus;
            /*execute a function when someone writes in the text field:*/
            inp.addEventListener("input", function (e) {
                var a, b, c, i, val = this.value;
                /*close any already open lists of autocompleted values*/
                closeAllLists();
                if (!val) { return false; }
                currentFocus = -1;
                /*create a DIV element that will contain the items (values):*/
                a = document.createElement("DIV");
                a.setAttribute("id", this.id + "autocomplete-list");
                a.setAttribute("class", "autocomplete-items");
                /*append the DIV element as a child of the autocomplete container:*/
                this.parentNode.appendChild(a);
                /*for each item in the array...*/
                for (i = 0; i < arr.length; i++) {
                    /*check if the item starts with the same letters as the text field value:*/
                    if (arr[i].substr(0, val.length).toUpperCase() == val.toUpperCase()) {
                        /*create a DIV element for each matching element:*/
                        b = document.createElement("DIV");
                        /*make the matching letters bold:*/
                        b.innerHTML = "<strong>" + arr[i].substr(0, val.length) + "</strong>";
                        b.innerHTML += arr[i].substr(val.length);
                        /*insert a input field that will hold the current array item's value:*/
                        b.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";
                        /*execute a function when someone clicks on the item value (DIV element):*/
                        b.addEventListener("click", function (e) {
                            /*insert the value for the autocomplete text field:*/
                            inp.value = this.getElementsByTagName("input")[0].value;
                            /*close the list of autocompleted values,
                            (or any other open lists of autocompleted values:*/
                            closeAllLists();
                        });
                        a.appendChild(b);
                    } else if (arr[i].toUpperCase().includes(val.toUpperCase())) {
                        /*create a DIV element for each matching element:*/
                        b = document.createElement("DIV");
                        /*make the matching letters bold:*/
                        c = arr[i].toUpperCase().indexOf(val.toUpperCase());
                        b.innerHTML = arr[i].substr(0,c);
                        b.innerHTML += "<strong>" + arr[i].substr(c, val.length) + "</strong>";
                        b.innerHTML += arr[i].substr(c+val.length);
                        /*insert a input field that will hold the current array item's value:*/
                        b.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";
                        /*execute a function when someone clicks on the item value (DIV element):*/
                        b.addEventListener("click", function (e) {
                            /*insert the value for the autocomplete text field:*/
                            inp.value = this.getElementsByTagName("input")[0].value;
                            /*close the list of autocompleted values,
                            (or any other open lists of autocompleted values:*/
                            closeAllLists();
                        });
                        a.appendChild(b);
                    }
                }
            });
            /*execute a function presses a key on the keyboard:*/
            inp.addEventListener("keydown", function (e) {
                var x = document.getElementById(this.id + "autocomplete-list");
                if (x) x = x.getElementsByTagName("div");
                if (e.keyCode == 40) {
                    /*If the arrow DOWN key is pressed,
                    increase the currentFocus variable:*/
                    currentFocus++;
                    /*and and make the current item more visible:*/
                    addActive(x);
                } else if (e.keyCode == 38) { //up
                    /*If the arrow UP key is pressed,
                    decrease the currentFocus variable:*/
                    currentFocus--;
                    /*and and make the current item more visible:*/
                    addActive(x);
                } else if (e.keyCode == 13) {
                    /*If the ENTER key is pressed, prevent the form from being submitted,*/
                    if (currentFocus > -1) {
                        
                        /*and simulate a click on the "active" item:*/
                        if (x) {
                            e.preventDefault();
                            x[currentFocus].click();
                        }
                    }
                }
            });
            function addActive(x) {
                /*a function to classify an item as "active":*/
                if (!x) return false;
                /*start by removing the "active" class on all items:*/
                removeActive(x);
                if (currentFocus >= x.length) currentFocus = 0;
                if (currentFocus < 0) currentFocus = (x.length - 1);
                /*add class "autocomplete-active":*/
                x[currentFocus].classList.add("autocomplete-active");
            }
            function removeActive(x) {
                /*a function to remove the "active" class from all autocomplete items:*/
                for (var i = 0; i < x.length; i++) {
                    x[i].classList.remove("autocomplete-active");
                }
            }
            function closeAllLists(elmnt) {
                /*close all autocomplete lists in the document,
                except the one passed as an argument:*/
                var x = document.getElementsByClassName("autocomplete-items");
                for (var i = 0; i < x.length; i++) {
                    if (elmnt != x[i] && elmnt != inp) {
                        x[i].parentNode.removeChild(x[i]);
                    }
                }
            }
            /*execute a function when someone clicks in the document:*/
            document.addEventListener("click", function (e) {
                closeAllLists(e.target);
            });
        }
        
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel ID="Panel1" runat="server" DefaultButton="btnSearch">
    <br />
        <div class="row" >
            <div class="col-11 autocomplete" >
            <asp:TextBox ID="tbSearch" runat="server" placeholder="Search.." Width="100%" autocomplete="off" CssClass="form-control"></asp:TextBox>

            </div>
            <div class="col-1">
                <asp:LinkButton runat="server" ID="btnSearch" OnClick="btnSearch_Click" Width="100%" CssClass="btn btn-primary">
                    <i class="fas fa-search"></i>
                </asp:LinkButton>
            </div>
            
            <div class="col-11" style="margin-top:10px;">
                Location: &nbsp;<asp:DropDownList ID="DropDownListLocation" runat="server" OnSelectedIndexChanged="DropDownListLocation_SelectedIndexChanged" AutoPostBack="True">
                    
                </asp:DropDownList>
                <%--&nbsp;
                Category: &nbsp;<asp:DropDownList ID="DropDownList1" runat="server">
                    <asp:ListItem>All</asp:ListItem>
                    <asp:ListItem>Retail Store</asp:ListItem>
                    <asp:ListItem>Restaurant</asp:ListItem>
                    <asp:ListItem>Salon</asp:ListItem>
                </asp:DropDownList>--%>
            </div>
            <div class="col-1" style="margin-top:10px;">
                <asp:LinkButton style="color:gray;" ID="LinkButtonHistory" runat="server" OnClick="LinkButtonHistory_Click">History</asp:LinkButton>
            </div>
        </div>
        <br />
        <br />
        <asp:ListView ID="ListViewSearchResult" runat="server" ItemPlaceholderID="PlaceHolderResult" OnPagePropertiesChanging="ListViewSearchResult_PagePropertiesChanging">
            <EmptyDataTemplate>
                    <table >
                        <tr>
                            <td>Your search did not match any documents.
                                <br /><br />
                                Suggestions:
                                <br /><br />
                                - Make sure that all words are spelled correctly.<br />
                                - Try different keywords.<br />
                                - Try more general keywords.<br />
                                - Try fewer keywords<br /></td>
                        </tr>
                    </table>
                </EmptyDataTemplate>
                <EmptyItemTemplate>
                    <td/>
                </EmptyItemTemplate>
            <ItemTemplate>
                <div class="card">
                    <div class="card-header">
                        <b><%# Eval("shopName") %></b><span class="text-muted" style="font-size:smaller;"> <%# Eval("avgRating") %></span>
                        <%--<span class="text-muted" style="font-size:smaller;">
                            Rating: <%# Eval("rating") %></span></div>--%>
                    <div class="card-body">
                   <%-- <h5 class="card-title"><%# Eval("Title") %></h5>--%>
                        <div class="row">
                            <div class="col-4 text-center" style="padding:5px;height:200px">
                                <img alt="Image" src="/Public/Image/SearchBG.png" class="img-fluid" style="max-height:100%;max-width:100%;" />
                            </div>
                            <div class="col-8">
                                <div class="row" style="height:155px;overflow:auto;margin-bottom:5px;">
                                    <div class="col-1">
                                        <span class="fa fa-location"></span>
                                    </div>
                                    <div class="col-11">
                                        <%# Eval("branchLocation") %> 
                                    </div>
                                    <div class="col-1">
                                        <span class="fa fa-map-marked"></span>
                                    </div>
                                    <div class="col-11 ">
                                       <%# Eval("branchAddress") %>
                                    </div>
                                    <div class="col-1">
                                        <span class="fa fa-list"></span>
                                    </div>
                                    <div class="col-11 ">
                                        <%# Eval("description") %>
                                    </div>
                                    <div class="col-1">
                                        <span class="fa fa-phone"></span>
                                    </div>
                                    <div class="col-11">
                                        <%# Eval("phoneNumber") %>
                                    </div>
                                </div>
                                <asp:Button ID="Button1" runat="server" Text="More Information" CommandArgument='<%#Eval("id")%>' OnClick="ButtonMoreInfomation_Click" CssClass="float-right btn btn-primary" style="margin-bottom:5px;"/>

                            </div>
                                
                            
                        </div>
                    </div>
                </div>
              </div>
                <%--<div class="col-5 text-center border border-dark" style="padding:5px;height:200px">
                    <img alt="Image" src="/Public/Image/SearchBG.png" class="img-fluid" style="max-height:100%;max-width:100%;" />
                </div>
                <div class="col-7 border border-dark" style="overflow-y:auto;height:200px;">
                    <b><%# Eval("shopName") %></b>
                    <div class ="row" style="min-height:130px;">
                        <div class="col-1">
                            <span class="fa fa-location"></span>
                        </div>
                        <div class="col-11">
                            <%# Eval("branchLocation") %> 
                        </div>
                        <div class="col-1">
                            <span class="fa fa-map-marked"></span>
                        </div>
                        <div class="col-11 ">
                           <%# Eval("branchAddress") %>
                        </div>
                        <div class="col-1">
                            <span class="fa fa-list"></span>
                        </div>
                        <div class="col-11 ">
                            <%# Eval("description") %>
                        </div>
                        <div class="col-1">
                            <span class="fa fa-phone"></span>
                        </div>
                        <div class="col-11">
                            <%# Eval("phoneNumber") %>
                        </div>
                    </div>
                    
                    <asp:Button ID="ButtonMoreInfomation" runat="server" Text="More Information" CommandArgument='<%#Eval("id")%>' OnClick="ButtonMoreInfomation_Click" CssClass="float-right btn btn-primary" style="margin-bottom:5px;"/>
               </div>--%>
            </ItemTemplate>
            <LayoutTemplate>
                
                    <asp:PlaceHolder runat="server" ID="PlaceHolderResult"></asp:PlaceHolder>
            </LayoutTemplate>
        </asp:ListView>

        <br />
        <asp:DataPager ID="lvDataPager1" runat="server" PagedControlID="ListViewSearchResult" PageSize="5" style="float:right;" >
            <Fields>
                <asp:NextPreviousPagerField ButtonType="Link" ShowFirstPageButton="true" ShowLastPageButton="false" ShowNextPageButton="false" ShowPreviousPageButton="true" ButtonCssClass="btn btn-dark" />
                <asp:NumericPagerField ButtonType="Link" NumericButtonCssClass="btn btn-light" CurrentPageLabelCssClass="btn btn-info" NextPreviousButtonCssClass="btn btn-secondary" />
                <asp:NextPreviousPagerField ButtonType="Link" ShowFirstPageButton="false" ShowLastPageButton="true" ShowNextPageButton="true" ShowPreviousPageButton="false" ButtonCssClass="btn btn-dark" />
            </Fields>
        </asp:DataPager>
        <br />
        <br />

    </asp:Panel>
    <script>
        var countries = <%= jsSerializer.Serialize(Names) %>;

        autocomplete(document.getElementById("<%=tbSearch.ClientID%>"), countries);
    </script>
</asp:Content>
