class ProgramEnrollmentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @program_enrollments = current_user.program_enrollments
  end

  def new
    @child = current_user.children.find(params[:child_id])
    @program_enrollment = @child.program_enrollments.new
  end

  def create
    @program = Program.find(params[:program_id])
    @child = current_user.children.find(params[:child_id])
    @program_enrollment = ProgramEnrollment.new(program: @program, child: @child)

    if @program_enrollment.save
      redirect_to @program, notice: "#{@child.name} has been enrolled in #{@program.name}."
    else
      redirect_to @program, alert: "Unable to enroll #{@child.name} in the program."
    end
  end

  def destroy
    @program_enrollment = ProgramEnrollment.find(params[:id])
    @program = @program_enrollment.program
    @child = @program_enrollment.child

    if @program_enrollment.destroy
      redirect_to @program, notice: "#{@child.name} has been unenrolled from #{@program.name}."
    else
      redirect_to @program, alert: "Unable to unenroll #{@child.name} from the program."
    end
  end

  private

  def program_enrollment_params
    params.require(:program_enrollment).permit(:program_id)
  end
end
