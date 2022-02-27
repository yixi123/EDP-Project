<%@ Page Title="" Language="C#" MasterPageFile="~/Client.Master" AutoEventWireup="true" CodeBehind="AdminReportedReview.aspx.cs" Inherits="EDP_Project.AdminReportedReview" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Reported Review</h1>
    <div class="alert alert-warning" role="alert" runat="server" id="alert" visible="false">
      <strong><asp:Label ID="lblAlert" runat="server" Text=""></asp:Label></strong>
    </div>
    <asp:ListView ID="ListViewReview" runat="server" ItemPlaceholderID="PlaceHolderResult">
            <EmptyDataTemplate>
                      <h5>No Reported Review Currrently</h5>
                </EmptyDataTemplate>
                <EmptyItemTemplate>
                </EmptyItemTemplate> 
            <ItemTemplate>
                <tr>
                  <th scope="row"><%#Eval("id")%></th>
                  <td><%# Eval("Title") %></td>
                  <td><%# Eval("comment") %></td>
                  <td><%# Eval("dateCreated") %></td>
                  <td><%# Eval("rating") %></td>
                  <td><%# Eval("numReport") %></td>
                  <td>
                      <asp:Button ID="ButtonReport" runat="server" Text="Reset Report" CommandArgument='<%#Eval("id")%>' OnClick="ButtonReset_Click" CssClass="btn btn-primary" style="margin-bottom:5px;"/>
                      <asp:Button ID="ButtonDelete" runat="server" Text="Delete Review" CommandArgument='<%#Eval("id")%>' OnClick="ButtonDelete_Click" CssClass="btn btn-danger" style="margin-bottom:5px;"/>
                  </td>
                </tr>
            </ItemTemplate>
            <LayoutTemplate>
                <table class="table">
                  <thead>
                    <tr>
                      <th scope="col">Id</th>
                      <th scope="col">Title</th>
                      <th scope="col">comment</th>
                      <th scope="col">dateCreated</th>
                      <th scope="col">rating</th>
                      <th scope="col">Num of Report</th>
                      <th scope="col"></th>
                    </tr>
                  </thead>
                  <tbody>
                    <asp:PlaceHolder runat="server" ID="PlaceHolderResult"></asp:PlaceHolder>
                   </tbody>
                </table>
             </LayoutTemplate>
        </asp:ListView>
</asp:Content>
