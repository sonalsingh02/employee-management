ActiveAdmin.register Employee do
	# See permitted parameters documentation:
	# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
	#
	# permit_params :list, :of, :attributes, :on, :model
	#
	index do
	 		selectable_column
	 		column "id"
	 		column "email"
	 		column "created_at"
	 		column "updated_at"
	 		column "encrypted_password"
	 		column "reset_password_token"
	 		column "leaves_balance"
	 		column "reset_password_sent_at"
	 		column "remember_created_at"
			column "Actions" do |resource|
	 			(link_to "View", admin_employee_path(resource)) + " " +
	  		(link_to "Edit", edit_admin_employee_path(resource)) + " " + (link_to "Delete", admin_employee_path(resource) , method: :delete ) + " " + (link_to "View Applied Leaves", show_leaves_employee_leaves_histories_path(resource))
	 		end
	end

	member_action :show_leaves do
	    employee = Employee.find(params[:id])
	    redirect_to :action => :show
	end


	show do |employee|
	    employee = Employee.find(params[:id])

	    div :class => "panel" do
		  h3 "Comments"
		  if employee.leaves_histories
	    	div :class => "panel_contents" do
	      	div :class => "attributes_table" do
	        	table do
	        		employee.leaves_histories.each do |leaves|
		          	tr do
		            	th do
		              	"Id"
		              end
		              th do
		              	"Start Date"
		              end
		              th do
		              	"End Date"
		              end
		              th do
		              	"Leaves Taken"
		              end
		              th do
		              	"Action"
		              end
		            end
		          end
	            tbody do
	            	employee.leaves_histories.each do |leaves|
	              	tr do
	                	td do
	                  	leaves.id
	                  end
	                  td do
	                  	leaves.start_date
	                  end
	                  td do
	                  	leaves.end_date
	                  end
	                  td do
	                  	leaves.leaves_taken
	                  end
	                  td do
	                  	(link_to "Approve", approve_leave_employee_leaves_histories_path(leaves))+ " " +(link_to "Disapprove", disapprove_leave_employee_leaves_histories_path(leaves))
	                  end
	                end
	              end
	            end
	          end
	        end
	      end
		  else
		  	h3 "No Leaves Available"
		  end
		end
	    redirect_to :action => :show
	end
end





