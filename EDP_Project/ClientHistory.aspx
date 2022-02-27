<%@ Page Title="" Language="C#" MasterPageFile="~/Client.Master" AutoEventWireup="true" CodeBehind="ClientHistory.aspx.cs" Inherits="EDP_Project.ClientHistory" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-8">
            <asp:LinkButton ID="LinkButtonClear" runat="server" CssClass="float-right" style="color:gray;margin-top:10px;" OnClick="LinkButtonClear_Click" OnClientClick="return confirm('Are you sure to delete history?')"><span class="fa fa-trash"></span>Clear</asp:LinkButton>
            <h2><asp:Label ID="lblType" runat="server" Text="View History"></asp:Label></h2>
            

                <asp:ListView ID="ListViewViewHistory" runat="server" ItemPlaceholderID="PlaceHolderViewHistory">
                    <EmptyDataTemplate>
                            <table >
                                <tr>
                                    <td>No View History.</td>
                                </tr>
                            </table>
                        </EmptyDataTemplate>
                        <EmptyItemTemplate>
                            <td/>
                        </EmptyItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblDate" runat="server" CssClass="col-12 h3" Visible="False"></asp:Label>
                        <div class="col-4 text-center border border-dark" style="padding:5px;height:120px">
                            <img alt="Image" src="/Public/Image/SearchBG.png" class="img-fluid" style="max-height:100%;max-width:100%;" />
                        </div>
                        <div class="col-7 border border-dark" style="overflow-y:auto;height:120px;">
                            <b><%# Eval("shopName") %></b>
                            <div class ="row">
                                <div class="col-1">
                                    <span class="fa fa-clock"></span>
                                </div>
                                <div class="col-11 text-primary">
                                    <asp:Label ID="lblViewTime" runat="server" Text='<%# Eval("viewDateTime","{0:hh:mm tt}") %>' ToolTip='Eval("searchDateTime")'></asp:Label> 
                                    <asp:Label runat="server" ID="lblViewDateTime" Text='<%# Eval("viewDateTime") %>' Visible="False"></asp:Label>
                                </div>
                                <div class="col-1">
                                    <span class="fa fa-map-marked"></span>
                                </div>
                                <div class="col-11 text-primary">
                                   <%# Eval("branchAddress") %>
                                </div>
                            </div>

                            <asp:Button ID="ButtonMoreInfomation" runat="server" Text="More Information" CommandArgument='<%#Eval("id")%>' OnClick="ButtonMoreInfomation_Click" CssClass="float-right btn btn-primary" style="margin-bottom:5px;"/>

                        </div>
                    </ItemTemplate>
                    <LayoutTemplate>
                        <div class="row" style="margin-bottom:0px;">
                            <asp:PlaceHolder runat="server" ID="PlaceHolderViewHistory"></asp:PlaceHolder>
                        </div>
                    </LayoutTemplate>
                </asp:ListView>


                <asp:ListView ID="ListViewSearchHistory" runat="server" ItemPlaceholderID="PlaceHolderSearchHistory" Visible="False">
                    <EmptyDataTemplate>
                            <table >
                                <tr>
                                    <td>No Search History.</td>
                                </tr>
                            </table>
                        </EmptyDataTemplate>
                        <EmptyItemTemplate>
                            <td/>
                        </EmptyItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblDate" runat="server" CssClass="col-12 h3" Visible="False"></asp:Label>
                        <div class="col-5 text-center border border-dark">
                            <span class="fa fa-clock"></span> <%# Eval("searchDateTime","{0:hh:mm tt}") %>
                            
                        </div>
                        <div class="col-7 text-center border border-dark">
                            <span class="fa fa-search"></span> <%# Eval("SearchString") %>
                            
                        </div>
                        <asp:Label runat="server" ID="lblSearchDateTime" Text='<%# Eval("searchDateTime") %>' Visible="False"></asp:Label>
                    </ItemTemplate>
                    <LayoutTemplate>
                        <div class="row">
                            <%--<asp:Label runat="server" Text='Search Date Time' CssClass="col-5 text-center border border-dark" Font-Bold="True"></asp:Label>
                        <asp:Label runat="server" Text='Search String' CssClass="col-7 text-center border border-dark" Font-Bold="True"></asp:Label>--%>
                            <asp:PlaceHolder runat="server" ID="PlaceHolderSearchHistory"></asp:PlaceHolder>
                        </div>
                    </LayoutTemplate>
                </asp:ListView>

                <asp:ListView ID="ListViewReviewHistory" runat="server" ItemPlaceholderID="PlaceHolderReviewHistory" Visible="false">
                    <EmptyDataTemplate>
                            <div class="card">
                              <h5 class="card-header">No Review History</h5>
                            </div>
                        </EmptyDataTemplate>
                        <EmptyItemTemplate>
                        </EmptyItemTemplate> 
                    <ItemTemplate>
                        <div class="card">
                            <div class="card-header">
                                <asp:LinkButton runat="server" CommandArgument='<%#Eval("branchId")%>' OnClick="ButtonShopLink_Click"> <%# Eval("shopName") %></asp:LinkButton>
                                <span class="text-muted" style="font-size:smaller;">
                                    Rating: <%# Eval("rating") %></span><span class="text-muted float-right" style="font-size:smaller;">
                                        created on: <%# Eval("dateCreated") %> </span></div>
                            <div class="card-body">
                            <h5 class="card-title"><%# Eval("Title") %></h5>
                            <p class="card-text"><%# Eval("comment") %></p>
                            </div>
                        </div>
                    </ItemTemplate>
                    <LayoutTemplate>
                       <asp:PlaceHolder runat="server" ID="PlaceHolderReviewHistory"></asp:PlaceHolder>
                    </LayoutTemplate>
                </asp:ListView>
        </div>
        <div class="col-4" style="height: fit-content;position: sticky;top: 90px;">
            <asp:Button ID="btnBack" runat="server" Text="Back" CssClass="float-right btn btn-primary" OnClick="btnBack_Click" style="margin-top:10px;"/>
            <h2>History Type</h2>
            
            <asp:RadioButton ID="RdbtnViewHistory" runat="server" GroupName="RdgroupHistoryType" Checked="True" Text="View History" OnCheckedChanged="RdgroupHistoryType_CheckedChanged" AutoPostBack="True" />
            <br /><asp:RadioButton ID="RdbtnSearchHistory" runat="server" GroupName="RdgroupHistoryType" Text="Search History" OnCheckedChanged="RdgroupHistoryType_CheckedChanged" AutoPostBack="True" />
            <br /><asp:RadioButton ID="RdbtnReviewHistory" runat="server" GroupName="RdgroupHistoryType" Text="Review History" OnCheckedChanged="RdgroupHistoryType_CheckedChanged" AutoPostBack="True" />
            <br />
            <br />
            <%--<asp:CheckBoxList ID="CheckBoxList1" runat="server">
                <asp:ListItem>Pause View History</asp:ListItem>
                <asp:ListItem>Pause Search History</asp:ListItem>
            </asp:CheckBoxList>--%>
        </div>
    </div>
</asp:Content>
