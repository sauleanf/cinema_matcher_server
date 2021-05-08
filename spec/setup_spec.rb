# frozen_string_literal: true

require 'rails_helper'

Rails.application.load_tasks

describe 'task:subtask', rakefile: 'setup' do
  let!(:file_path) { File.join('config', 'smtp.yml') }

  before do
    # to prevent the helpful tips from cluttering tests
    allow_any_instance_of(IO).to receive(:puts)
  end

  describe 'config_check' do
    context 'when file does not exist' do
      before do
        allow(File).to receive(:file?).with(file_path).and_return(false)
      end

      it 'raises an exception when a file is not present' do
        expect do
          Rake::Task['setup:check_configs'].execute
        end.to raise_error('Missing smtp.yml config file')
      end
    end

    context 'when file does exist' do
      before do
        allow(File).to receive(:file?).with(file_path).and_return(true)
      end

      it 'passes' do
        expect do
          Rake::Task['setup:check_configs'].execute
        end.not_to raise_error
      end
    end
  end

  describe 'check_environment' do
    before do
      allow(File).to receive(:file?).with(file_path).and_return(true)
    end

    NECESSARY_ENVS.each do |env_var|
      context "when #{env_var} is not set" do
        it 'raises an exception' do
          ENV[env_var] = nil
          (NECESSARY_ENVS - [env_var]).each do |other_env_var|
            ENV[other_env_var] = 'valid'
          end

          expect do
            Rake::Task['setup:check_environment'].execute
          end.to raise_error("#{env_var} is not set")
        end
      end
    end

    context 'when all environment variables are set' do
      it 'passes' do
        NECESSARY_ENVS.each do |env_var|
          ENV[env_var] = 'valid'
        end

        expect do
          Rake::Task['setup:check_environment'].execute
        end.not_to raise_error
      end
    end
  end

  describe 'sqs' do
    let!(:queues) do
      {
        'queues' => [
          ['queue_1', 1]
        ]
      }
    end

    before do
      allow(YAML).to receive(:load_file).and_return(queues)
    end

    it 'creates an sqs queue' do
      expect_any_instance_of(Kernel).to receive(:system).with('shoryuken sqs create queue_1')
      Rake::Task['setup:sqs'].execute
    end
  end

  describe 'all' do
    let!(:task_stub) { double }

    it 'executes the other setup tasks' do
      expect(task_stub).to receive(:execute).exactly(3)

      allow(Rake::Task).to receive(:[]).and_call_original
      allow(Rake::Task).to receive(:[]).with('setup:check_configs').and_return(task_stub)
      allow(Rake::Task).to receive(:[]).with('setup:check_environment').and_return(task_stub)
      allow(Rake::Task).to receive(:[]).with('setup:sqs').and_return(task_stub)

      Rake::Task['setup:all'].execute
    end
  end
end
