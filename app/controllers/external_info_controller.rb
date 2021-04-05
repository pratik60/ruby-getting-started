class ExternalInfoController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:initialize_url, :submit_url, :submit_sheet_url]
  after_action :allow_iframe, only: :submit_sheet_url

  # GET /widgets
  # GET /widgets.json
  def initialize_url
    Rails.logger.info("Params for initialize_url:#{params}")
    render json: {
      canvas: {
        content: {
          components: [
              {
                "type": "input",
                "id": "address",
                "label": "Address",
                "placeholder": "Enter address here...",
                "save_state": "unsaved"
              },
              {
                "type": "input",
                "id": "pincode",
                "label": "Pincode",
                "placeholder": "Enter pincode here...",
                "save_state": "unsaved"
              },
            { type: "button", 
            label: "Verify your details", 
            style: "primary", 
            id: "verification_form", 
            action: {type: "submit"} 
          },
          ], 
        },
      },
    }
  end

  def submit_url
    Rails.logger.info("Params for submit_url:#{params}")
    if params["external_info"]["input_values"]["pincode"] != "n7"
      render json: {
        canvas: {
          content: {
            components: [
                {
                  "type": "input",
                  "id": "address",
                  "label": "Address",
                  "placeholder": "Enter address here...",
                  "save_state": "unsaved"
                },
                {
                  "type": "input",
                  "id": "pincode",
                  "label": "Pincode",
                  "placeholder": "Enter pincode here...",
                  "save_state": "failed"
                },
              { type: "button", 
              label: "Verify your details", 
              style: "primary", 
              id: "verification_form", 
              action: {type: "submit"} 
            },
            ], 
          },
        },
      }
    else
      render json: {
        canvas: {
          content: {
            components: [
              { type: "button", label: "Submit meter reading", style: "primary", id: "meter_reading_submission", 
                action: {
                  type: "sheet",
                  url:  "https://obscure-dusk-46824.herokuapp.com/submit-sheet-url"
                }
              },
            ], 
          },
        },
      }
    end
  end

  def submit_sheet_url
    render layout: "balance"
  end

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

  # GET /widgets/1
  # GET /widgets/1.json
  def show
  end

  # GET /widgets/new
  def new
    @widget = Widget.new
  end

  # GET /widgets/1/edit
  def edit
  end

  # POST /widgets
  # POST /widgets.json
  def create
    @widget = Widget.new(widget_params)

    respond_to do |format|
      if @widget.save
        format.html { redirect_to @widget, notice: 'Widget was successfully created.' }
        format.json { render :show, status: :created, location: @widget }
      else
        format.html { render :new }
        format.json { render json: @widget.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /widgets/1
  # PATCH/PUT /widgets/1.json
  def update
    respond_to do |format|
      if @widget.update(widget_params)
        format.html { redirect_to @widget, notice: 'Widget was successfully updated.' }
        format.json { render :show, status: :ok, location: @widget }
      else
        format.html { render :edit }
        format.json { render json: @widget.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /widgets/1
  # DELETE /widgets/1.json
  def destroy
    @widget.destroy
    respond_to do |format|
      format.html { redirect_to widgets_url, notice: 'Widget was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_widget
      @widget = Widget.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def widget_params
      params.require(:widget).permit(:name, :description, :stock)
    end
end
