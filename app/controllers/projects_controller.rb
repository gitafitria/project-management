class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  has_scope :by_clients, type: :array
  has_scope :by_creators, type: :array
  has_scope :by_status

  respond_to :js, :json, :html
  # GET /projects
  # GET /projects.json
  def index
    require 'will_paginate/array'

    @projects = apply_scopes(Project).valid.order("created_at DESC").all
    respond_with do |format|
      format.html
      format.json { render json: ProjectsDatatable.new(view_context, @projects) }
      format.js
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        if @project.quotation_id.present?
          quotation = Quotation.find(@project.quotation_id)
          quotation.update_attribute(:project_id, @project.id)
        end
        flash_label = 'Project was successfully created.'
        flash.now[:notice] = flash_label

        format.html { redirect_to @project, notice: flash_label }
        format.json { render :show, status: :created, location: @project }
        format.js
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        flash_label = 'Project was successfully updated.'
        flash.now[:notice] = flash_label

        format.html { redirect_to @project, notice: flash_label }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      # params.fetch(:kitten, {}) is just an ActiveSupport way accessing a hash key and retrurning a default value if it is not set. In plain ruby it would read params[:kitten] || {}.
      # params.fetch(:project, {})

      params.require(:project).permit(
        :project_name,
        :description,
        :user_id,
        :is_valid,
        :status,
        :quotation_id,
        client_ids: [],
        milestones_attributes: [
          :id,
          :label,
          :goal,
          :project_id,
          :user_id,
          :is_valid,
          :_destroy
        ]
      )
    end
end