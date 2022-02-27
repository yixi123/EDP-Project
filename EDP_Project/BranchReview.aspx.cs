using EDP_Project.MyDBServiceReference;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EDP_Project
{
    public partial class BranchReview : System.Web.UI.Page
    {
        MyDBServiceReference.Service1Client client = new MyDBServiceReference.Service1Client();
        public Branch branch;
        public Review review = new Review();
        public string ratingString = "No Rating yet";
        protected void Page_Load(object sender, EventArgs e)
        {
            review.Id = -1;
            Guid id;
            if (Guid.TryParse(Request.QueryString["id"], out id))
            {
                branch = client.SelectByIdFromBranch(id);
                double rating = client.SelectRatingByBranchIdFromReview(id);
                if(rating != 0)
                {
                    ratingString = "Average Rating: " + String.Format("{0:00.00}", rating);
                }
                
            }
            if (Session["userId"] == null)
            {
                btnAddReview.Visible = false;
            }
            else
            {
                review = client.HaveExistingReview(branch.Id, Guid.Parse(Session["userId"].ToString()));
            }
            if (!IsPostBack)
            {
                populate_listview();
            }
            

        }

        protected override void OnPreRender(EventArgs e)
        {
            if (Session["userId"] != null)
            {
                review = client.HaveExistingReview(branch.Id, Guid.Parse(Session["userId"].ToString()));
            }
            populate_listview();
            
            base.OnPreRender(e);
        }
        protected void populate_listview()
        {
            string selectedValue = DropDownListSort.SelectedValue.ToString();
            
            DataSet ds;
            if (Session["userId"] == null)
            {
                ds = client.SelectAllByBranchIdFromReview(branch.Id, selectedValue);
            }
            else
            {
                ds = client.SelectByBranchIdFromReview(branch.Id, Guid.Parse(Session["userId"].ToString()), selectedValue);
            }
            ListViewReview.DataSource = ds;
            ListViewReview.DataBind();

            if (review.Id != -1)
            {
                btnAddReview.Text = "Edit My Review";
                lblAddReview.Text = "Edit My Review";
                tbRating.Text = review.Rating.ToString();
                tbReviewTitle.Text = review.Title;
                tbReviewContent.Text = review.Comment;
                btnDeleteReview.Visible = true;
                currentReview.Visible = true;
            }
        }


        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("ClientSearch.aspx");
        }
        protected void btnDeleteReview_Click(object sender, EventArgs e)
        {
            if (review.Id != -1)
            {
                client.DeleteReview(review.Id);
            }
            alert.Visible = true;
            lblAlert.Text = "Review Removed Successfully";

            btnDeleteReview.Visible = false;
            btnAddReview.Text = "Add Review";
            lblAddReview.Text = "Add Review";
            tbRating.Text = "50";
            tbReviewTitle.Text = "";
            tbReviewContent.Text = "";
            review = new Review();
            currentReview.Visible = false;
        }

        protected void btnSubmitReview_Click(object sender, EventArgs e)
        {
            if (Session["userId"] != null)
            {
                double rating = double.Parse(tbRating.Text);
                string comment = tbReviewContent.Text;
                string title = tbReviewTitle.Text;
                if (string.IsNullOrEmpty(comment) || string.IsNullOrEmpty(title))
                {
                    if (string.IsNullOrEmpty(comment))
                    {
                        tbReviewContent.Text = "Please Enter Comment";
                    }
                    if (string.IsNullOrEmpty(title))
                    {
                        tbReviewTitle.Text = "Please Enter a Title";
                    }
                    alert.Visible = true;
                    lblAlert.Text = "Missing Title or Comment";
                }
                else
                {
                    if (review.Id == -1)
                    {
                        client.InsertReview(rating, comment, title, Guid.Parse(Session["userId"].ToString()), branch.Id);
                        alert.Visible = true;
                        lblAlert.Text = "Review Created Successfully";
                    }
                    else
                    {
                        client.UpdateReview(review.Id, title, comment, rating);
                        alert.Visible = true;
                        lblAlert.Text = "Review Updated Successfully";
                    }
                }
            }
            else
            {
                alert.Visible = true;
                lblAlert.Text = "Please Login first";
            }
        }

        protected void DropDownListSort_SelectedIndexChanged(object sender, EventArgs e)
        {
            populate_listview();
        }

        protected void ButtonReport_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            if (Session["userId"] != null)
            {
                client.AddNumReportToReview(int.Parse(btn.CommandArgument));
                alert.Visible = true;
                lblAlert.Text = "Report Review Successfully!";
            }
            else
            {
                alert.Visible = true;
                lblAlert.Text = "Please Login first";
            }
        }

    }
}