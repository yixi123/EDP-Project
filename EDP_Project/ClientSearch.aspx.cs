using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EDP_Project
{
    public partial class ClientSearch : System.Web.UI.Page
    {
        public List<string> Names;
        public JavaScriptSerializer jsSerializer = new JavaScriptSerializer();
        MyDBServiceReference.Service1Client client = new MyDBServiceReference.Service1Client();
        
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //Testing
                Session["userId"] = new Guid();
                
                
                if (Session["userId"] == null)
                {
                    LinkButtonHistory.Visible = false;
                }

                // Dropdown box
                DataSet ds = client.SelectDistinctLocationFromBranch();
                DropDownListLocation.DataSource = ds;
                DropDownListLocation.DataTextField = "branchLocation";
                DropDownListLocation.DataValueField = "branchLocation";
                DropDownListLocation.DataBind();
                DropDownListLocation.Items.Insert(0, new ListItem("All", "All"));
                if (Session["search"] == null)
                {
                    Session["search"] = "";
                }

                // Display search Result
                BindListView();
            }
            
            // Autofill for search

            Names = client.SelectDistinctShopNameFromBranch().ToList<String>();

           
        }

        
        protected void BindListView()
        {
            string location = DropDownListLocation.SelectedValue.ToString();
            DataSet ds = client.SearchFromBranch(Session["search"].ToString(), location);
            ListViewSearchResult.DataSource = ds;
            ListViewSearchResult.DataBind();

        }

        protected void ListViewSearchResult_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
        {
            
            //set current page startindex, max rows and rebind to false
            lvDataPager1.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);

            //rebind List View
            BindListView();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            Session["search"] = tbSearch.Text.Trim();
            if (Session["userId"] != null)
            {
                if (!String.IsNullOrEmpty(Session["search"].ToString()))
                {
                    int id = client.HaveDateFromSearch(Session["search"].ToString(), Guid.Parse(Session["userId"].ToString()));
                    if (id == 0)
                    {
                        client.CreateSearch(Session["search"].ToString(), Guid.Parse(Session["userId"].ToString()));
                    }
                    else
                    {
                        client.UpdateSearch(id);
                    }
                   
                }
            }
            lvDataPager1.SetPageProperties(0, 5, false);
            BindListView();

        }

        protected void DropDownListLocation_SelectedIndexChanged(object sender, EventArgs e)
        {
            lvDataPager1.SetPageProperties(0, 5, false);
            BindListView();
        }

        protected void ButtonMoreInfomation_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            if(Session["userId"] != null)
            {
                int id = client.HaveDateFromView(Guid.Parse(btn.CommandArgument.ToString()), Guid.Parse(Session["userId"].ToString()));
                if (id == 0)
                {
                    client.InsertView(Guid.Parse(btn.CommandArgument.ToString()), Guid.Parse(Session["userId"].ToString()));
                }
                else
                {
                    client.UpdateView(id);
                }
                
            }

            Response.Redirect("BranchReview.aspx?id=" + btn.CommandArgument.ToString());
        }

        protected void LinkButtonHistory_Click(object sender, EventArgs e)
        {
            Response.Redirect("ClientHistory.aspx");
        }
    }
}

