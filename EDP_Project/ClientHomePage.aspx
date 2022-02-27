<%@ Page Language="C#" MasterPageFile="~/Client.Master" AutoEventWireup="true" CodeBehind="ClientHomePage.aspx.cs" Inherits="EDP_Project.ClientHomePage" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        body {
    background-image:url("/Public/Image/SearchBG.png");
    background-repeat:no-repeat;
    background-attachment:fixed;
    background-size:cover;
}

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container" style="margin-top:25vh;">
        <div style="padding:5px;width:60%;text-align:center;color:orange;margin:auto; background-color:white;box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);">
            <p><b>Welcome to PinPoint</b></p>
            <p>PinPoint is a business search directory website.<br />Our aim is to gather all the business located in Singapore<br />and put them into a search directory for you.</p>
            <asp:Button ID="btnSearch" runat="server" Text="Start Searching" CssClass="btn-primary" OnClick="btnSearch_Click" style="width:150px;height:40px;" Font-Bold="True"/>

        </div>

        <div class="text-center" style="margin-top: 28vh;">
            <%--Language offered: <a href="#">English</a>&nbsp&nbsp<a href="#">中文(简体)</a>&nbsp&nbsp<a href="#">Melayu</a>--%>
        </div>
    </div>
</asp:Content>
