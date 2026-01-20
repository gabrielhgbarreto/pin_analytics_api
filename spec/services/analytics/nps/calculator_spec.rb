require "rails_helper"

RSpec.describe Analytics::Nps::Calculator do
  describe "#execute" do
    let(:job) { Job.create(title: "Developer", function_name: "Engineering") }
    let(:department) { Department.create(name: "Technology") }
    let!(:question) { Question.create(text: "eNPS") }

    def create_response(score:, department:, tenure: :less_than_one_year, question_text: "eNPS")
      question = Question.find_by(text: question_text) || Question.create!(text: question_text)

      unique_suffix = SecureRandom.hex(4)

      employee = Employee.create!(
        name: "Employee #{unique_suffix}",
        corporate_email: "emp#{unique_suffix}@example.com",
        department: department,
        job: job,
        tenure: tenure
      )

      submission = Submission.create!(employee: employee, responded_at: Time.current)
      Answer.create!(submission: submission, question: question, score_value: score)
    end

    context "calculation logic" do
      it "calculates NPS correctly" do
        create_response(score: 10, department: department)
        create_response(score: 9, department: department)
        create_response(score: 8, department: department)
        create_response(score: 5, department: department)

        calculator = described_class.new
        expect(calculator.execute).to eq(25.0)
      end

      it "returns 0 when there are no responses" do
        calculator = described_class.new
        expect(calculator.execute).to eq(0)
      end

      it "ignores answers from other questions" do
        create_response(score: 10, department: department, question_text: "Outra Pergunta")

        calculator = described_class.new
        expect(calculator.execute).to eq(0)
      end
    end

    context "filtering by department" do
      let(:child_department) { Department.create!(name: "Backend", parent: department) }
      let(:other_department) { Department.create!(name: "HR") }

      before do
        create_response(score: 10, department: department)
        create_response(score: 10, department: child_department)
        create_response(score: 0, department: other_department)
      end

      it "includes subtree (child departments) when filtering by parent department" do
        calculator = described_class.new(department_id: department.id)
        expect(calculator.execute).to eq(100.0)
      end

      it "scopes strictly when filtering by a specific leaf department" do
        create_response(score: 0, department: department)

        calculator = described_class.new(department_id: child_department.id)
        expect(calculator.execute).to eq(100.0)
      end
    end

    context "filtering by tenure" do
      before do
        create_response(score: 10, department: department, tenure: :less_than_one_year)
        create_response(score: 0, department: department, tenure: :one_to_two_years)
      end

      it "filters by specific tenure" do
        expect(described_class.new(tenure: 1).execute).to eq(100.0)
        expect(described_class.new(tenure: 2).execute).to eq(-100.0)
      end

      it "raises ArgumentError for invalid tenure" do
        expect { described_class.new(tenure: 999).execute }.to raise_error(ArgumentError, /Tenure inválido/)
      end
    end
  end
end
