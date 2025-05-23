class PeopleController < ApplicationController
  include ReportsHelper
  include PeopleHelper

  before_action :set_person, only: %i[ show edit update destroy new_membership ]
  
  # GET /people or /people.json
  def index
    filter
    render partial: 'index' if(params[:page])

    respond_to do |format|
      format.html
      format.csv { send_data to_csv(models: @all_people), filename: "sjaa-people-#{Date.today}.csv" }
    end
  end
  
  # GET /people/1 or /people/1.json
  def show
  end

  def new_membership
  end

  def create_membership
  end
  
  def search
    filter
    render turbo_stream: turbo_stream.replace('people', partial: 'index')
  end
  
  # GET /people/new
  def new
    @person = Person.new
    @person.interests.build
  end
  
  # GET /people/1/edit
  def edit
  end
  
  # POST /people or /people.json
  def create
    @person = Person.new(person_params)
    
    respond_to do |format|
      if @person.save
        format.html { redirect_to @person, notice: "Person was successfully created." }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /people/1 or /people/1.json
  def update
    respond_to do |format|
      begin
        update_success = @person.update(person_params)
      rescue => e
        update_success = false
        @person.errors.add :exception, e.message
      end

      if update_success && !@person.errors.any?
        format.html { redirect_to @person, notice: "Person was successfully updated." }
        format.json { render :show, status: :ok, location: @person }
      else
        flash[:alert] = "Problem updating person: <ul>#{@person.errors.full_messages.map{|er| "<li>#{er}</li>"}.join('  ')}</ul>"
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /people/1 or /people/1.json
  def destroy
    @person.destroy!
    
    respond_to do |format|
      format.html { redirect_to people_path, status: :see_other, notice: "Person was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_person
    @person = Person.find(params[:id])
  end
  
  # Only allow a list of trusted parameters through.
  def person_params
    params.require(:person).permit(
    :first_name, :last_name, :astrobin_id, :notes, :membership_id, :discord_id, :referral_id,
    interests_attributes: [:name, :id], 
    roles_attributes: [:id], 
    contact_attributes: [:address, :zipcode, :phone, :state_id, :city_id, :city_name, :email, :primary, :person_id, :id], 
    membership_attributes: [:start, :kind, :kind_id, :term_months, :new, :ephemeris, :id, :person_id],
    astrobin_attributes: [:username, :latest_image, :id])
  end
  
  def policy_handling
    begin
      set_person
      puts("Authorizing #{@person.inspect}")
      authorize @person, policy_class: PersonPolicy
    rescue => e
      puts("Person not set! #{e.message}")
      authorize self.class, policy_class: PersonPolicy
    end
  end
end
