using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EDP_Project
{
    public partial class ClientHistory : System.Web.UI.Page
    {
        MyDBServiceReference.Service1Client client = new MyDBServiceReference.Service1Client();
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Session["userId"] == null)
            {
                Response.Redirect("ClientSearch.aspx",false);


            }
            else
            {
                if (!IsPostBack)
                {
                    populate_listview();

                }
            }
            
        }
        protected override void OnPreRender(EventArgs e)
        {
            populate_listview();

            base.OnPreRender(e);
        }
        protected void populate_listview()
        {
            DataSet ds = client.SelectByCustomerIdFromView(Guid.Parse(Session["userId"].ToString()));
            ListViewViewHistory.DataSource = ds;
            ListViewViewHistory.DataBind();

            DateTime previousDate = DateTime.MinValue;
            foreach (ListViewItem li in ListViewViewHistory.Items)
            {
                Label lblDate = (Label)li.FindControl("lblDate");
                Label lblDatetime = (Label)li.FindControl("lblViewDateTime");

                if (DateTime.Parse(lblDatetime.Text).Date != previousDate.Date)
                {
                    lblDate.Text = DateTime.Parse(lblDatetime.Text).ToString("dddd, dd MMMM yyyy");
                    lblDate.Visible = true;
                }

                previousDate = DateTime.Parse(lblDatetime.Text);

            }

            ds = client.SelectByCustomerIdFromSearch(Guid.Parse(Session["userId"].ToString()));
            ListViewSearchHistory.DataSource = ds;
            ListViewSearchHistory.DataBind();

            previousDate = DateTime.MinValue;
            foreach (ListViewItem li in ListViewSearchHistory.Items)
            {
                Label lblDate = (Label)li.FindControl("lblDate");
                Label lblDatetime = (Label)li.FindControl("lblSearchDateTime");

                if (DateTime.Parse(lblDatetime.Text).Date != previousDate.Date)
                {
                    lblDate.Text = DateTime.Parse(lblDatetime.Text).ToString("dddd, dd MMMM yyyy");
                    lblDate.Visible = true;
                }

                previousDate = DateTime.Parse(lblDatetime.Text);
            }

            ds = client.SelectByCustomerIdFromReview(Guid.Parse(Session["userId"].ToString()));
            ListViewReviewHistory.DataSource = ds;
            ListViewReviewHistory.DataBind();
        }
        protected void RdgroupHistoryType_CheckedChanged(object sender, EventArgs e)
        {
            if (RdbtnViewHistory.Checked)
            {
                lblType.Text = "View History";
                ListViewViewHistory.Visible = true;
                ListViewSearchHistory.Visible = false;
                ListViewReviewHistory.Visible = false;
                LinkButtonClear.Visible = true;
            }

            if (RdbtnSearchHistory.Checked)
            {

                lblType.Text = "Search History";
                ListViewViewHistory.Visible = false;
                ListViewSearchHistory.Visible = true;
                ListViewReviewHistory.Visible = false;
                LinkButtonClear.Visible = true;
            }

            if (RdbtnReviewHistory.Checked)
            {
                lblType.Text = "Review History";
                ListViewViewHistory.Visible = false;
                ListViewSearchHistory.Visible = false;
                ListViewReviewHistory.Visible = true;
                LinkButtonClear.Visible = false;
            }
        }


        protected void ButtonMoreInfomation_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            if (Session["userId"] != null)
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

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("ClientSearch.aspx");
        }

        protected void LinkButtonClear_Click(object sender, EventArgs e)
        {
            if (RdbtnViewHistory.Checked)
            {
                client.DeleteFromView(Guid.Parse(Session["userId"].ToString()));
            }

            if (RdbtnSearchHistory.Checked)
            {
                client.DeleteFromSearch(Guid.Parse(Session["userId"].ToString()));
            }
        }

        protected void ButtonShopLink_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            if (Session["userId"] != null)
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
    }
}