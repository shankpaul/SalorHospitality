# BillGastro -- The innovative Point Of Sales Software for your Restaurant
# Copyright (C) 2011  Michael Franzl <michael@billgastro.com>
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

class CategoriesController < ApplicationController
  before_filter :check_permission
  def index
    @categories = Category.accessible_by(@current_user).existing
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(Category.process_custom_icon(params[:category]))
    if @category.save then
      flash[:notice] = I18n.t("categories.create.success")
      redirect_to(categories_path)
    else
      render :new
    end
  end

  def edit
    @category = Category.accessible_by(@current_user).find(params[:id])
    render :new
  end

  def update
    @category = @permitted_model
    if @category.update_attributes(Category.process_custom_icon(params[:category])) then
      flash[:notice] = I18n.t("categories.update.success")
      redirect_to(categories_path)
    else
      render(:new)
    end
  end

  def destroy
    @category = Category.scopied.find(params[:id])
    @category.update_attribute :hidden, true
    redirect_to categories_path
  end

  def sort
    @categories = Category.scopied.all
    @categories.each do |c|
      c.position = params['category'].index(c.id.to_s) + 1
      c.save
    end
  render :nothing => true
  end

end
