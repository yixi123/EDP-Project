<%@ Page Title="" Language="C#" MasterPageFile="~/Client.Master" AutoEventWireup="true" CodeBehind="BranchReview.aspx.cs" Inherits="EDP_Project.BranchReview" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="alert alert-warning" role="alert" runat="server" id="alert" visible="false">
      <strong><asp:Label ID="lblAlert" runat="server" Text=""></asp:Label></strong>
    </div>
    <div>
        <asp:Button ID="btnBack" runat="server" Text="Back" CssClass="float-right btn btn-primary" OnClick="btnBack_Click" style="margin:10px;"/>
    </div>
    <h2><%= branch.ShopName %> - Review</h2><span class="text-muted" style="font-size:smaller;"><%= ratingString %></span>
    <div class="row w-100">
        <div class="col-5 text-center border border-dark" style="padding:5px;height:200px">
            <img alt="Image" src="/Public/Image/SearchBG.png" class="img-fluid" style="max-height:100%;max-width:100%;" />
         </div>
        <div class="col-7 border border-dark" style="overflow-y:auto;height:200px;">
            <b><%= branch.ShopName %></b>
            <div class ="row" style="min-height:130px;">
                <div class="col-1">
                    <span class="fa fa-location"></span>
                </div>
                <div class="col-11 text-primary">
                    <%= branch.Location %>
                </div>
                <div class="col-1">
                    <span class="fa fa-map-marked"></span>
                </div>
                <div class="col-11 text-primary">
                    <%= branch.Address %>
                </div>
                <div class="col-1">
                    <span class="fa fa-list"></span>
                </div>
                <div class="col-11 text-primary">
                    <%= branch.Description %>
                </div>
                <div class="col-1">
                    <span class="fa fa-phone"></span>
                </div>
                <div class="col-11">
                    <%= branch.PhoneNumber %>
                </div>
            </div>
        </div>
    </div>
    <br />
    <div class="card">
      <h5 class="card-header">Review 
          <asp:Button ID="btnAddReview" runat="server" Text="Add Review" CssClass="float-right btn btn-secondary" OnClientClick="toogleAddReview();return false;" UseSubmitBehavior="False" />
          <small style="float:right;margin-right:10px;">Sort by: <asp:DropDownList ID="DropDownListSort" runat="server" OnSelectedIndexChanged="DropDownListSort_SelectedIndexChanged" AutoPostBack="True">
            <asp:ListItem>Newest</asp:ListItem>
              <asp:ListItem>Oldest</asp:ListItem>
            <asp:ListItem>Highest Rating</asp:ListItem>
            <asp:ListItem>Lowest Rating</asp:ListItem>
          </asp:DropDownList></small>
      </h5>
      <div class="card-body">
        <div class="card bg-light" id="addReview" style="display:none;">
            <div class="card-header"><asp:Label ID="lblAddReview" runat="server" Text="Add Review"></asp:Label></div>
            <div class="card-body">
            <h5 class="card-title">Title: <asp:TextBox ID="tbReviewTitle" runat="server" CssClass="w-75" placeholder="Title"></asp:TextBox></h5>
            <p class="card-text">Content: <asp:TextBox ID="tbReviewContent" runat="server" CssClass="w-100" TextMode="MultiLine" placeholder="Comment"></asp:TextBox>
                Rating: <asp:TextBox ID="tbRating" runat="server" CssClass="w-25" TextMode="Range" OnClick="onValueChanged();"></asp:TextBox> <span id="Text1">50</span>
                <asp:Button ID="btnSubmitReview" runat="server" Text="Confirm" CssClass="btn btn-primary float-right" OnClick="btnSubmitReview_Click" />
                <asp:Button ID="btnDeleteReview" runat="server" Text="Remove" CssClass="btn btn-danger float-right" style="margin-right:20px;" OnClick="btnDeleteReview_Click" OnClientClick="return confirm('Remove your review?');" Visible="false" />
            </p>
            </div>
        </div>
        <div class="card bg-light" runat="server" id="currentReview" visible="false">
            <div class="card-header">
                User Name 
                <span class="text-muted" style="font-size:smaller;"> (You) Rating: <%= review.Rating.ToString() %></span>
                <span class="text-muted float-right" style="font-size:smaller;">Created on: <%= review.DateCreated %></span>
            </div>
            <div class="card-body">
            <h5 class="card-title"><%= review.Title %></h5>
            <p class="card-text"><%= review.Comment %></p>
            </div>
        </div>
        <asp:ListView ID="ListViewReview" runat="server" ItemPlaceholderID="PlaceHolderResult">
            <EmptyDataTemplate>
                    <div class="card">
                      <h5 class="card-header">No Others Review Currrently</h5>
                    </div>
                </EmptyDataTemplate>
                <EmptyItemTemplate>
                </EmptyItemTemplate> 
            <ItemTemplate>
                <div class="card">
                    <div class="card-header">
                        <%# Eval("CustomerId") %>
                        <span class="text-muted" style="font-size:smaller;">
                            Rating: <%# Eval("rating") %></span><span class="text-muted float-right" style="font-size:smaller;">
                                created on: <%# Eval("dateCreated") %> </span></div>
                    <div class="card-body">
                    <h5 class="card-title"><%# Eval("Title") %></h5>
                    <p class="card-text"><%# Eval("comment") %></p>
                    <asp:Button ID="ButtonReport" runat="server" Text="Report Review" CommandArgument='<%#Eval("id")%>' OnClick="ButtonReport_Click" CssClass="btn btn-danger" style="margin-bottom:5px;"/>
                    </div>
                    
                </div>
            </ItemTemplate>
            <LayoutTemplate>
               <asp:PlaceHolder runat="server" ID="PlaceHolderResult"></asp:PlaceHolder>
            </LayoutTemplate>
        </asp:ListView>
      </div>
    </div>
    <script type="text/javascript">
        function onValueChanged() {
            document.getElementById("Text1").innerText = document.getElementById("<%= tbRating.ClientID %>").value;
        }
        document.getElementById("Text1").innerText = document.getElementById("<%= tbRating.ClientID %>").value;
        function toogleAddReview() {
            if (document.getElementById("addReview").style.display == "none") {
                document.getElementById("addReview").style.display = "";
                document.getElementById("<%= currentReview.ClientID %>").style.display = "none";
            } else {
                document.getElementById("addReview").style.display = "none";
                document.getElementById("<%= currentReview.ClientID %>").style.display = "";
            }
        }
    </script>
</asp:Content>
