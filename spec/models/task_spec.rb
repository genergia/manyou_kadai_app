require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空の場合' do
      it 'バリデーションにひっかる' do
        task = Task.new(task_name: '', content: '失敗テスト', status: '未着手',priority: 2,end_date: 20230405, )
        expect(task).not_to be_valid
      end
    end
    context 'タスクの詳細が空の場合' do
      it 'バリデーションにひっかかる' do
        task = Task.new(task_name: '失敗テスト', content: '', status: '未着手',priority: 2,end_date: 20230405, )
        expect(task).not_to be_valid
      end
    end
    context 'タスクのタイトルと詳細に内容が記載されている場合' do
      it 'バリデーションが通る' do
        task = Task.new(task_name: '失敗テスト', content: '失敗テスト', status: '未着手',priority: 2,end_date: 20230405, )
        expect(task).to be_valid
      end
    end
  end
end
describe 'タスクモデル機能', type: :model do
  describe '検索機能' do
    let!(:task) { FactoryBot.create(:task, task_name: 'テスト', status: '未着手') }
    let!(:second_task) { FactoryBot.create(:task, task_name: "てすと", status: '完了') }
    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it "検索キーワードを含むタスクが絞り込まれる" do
        expect(Task.search_task_name('テスト')).to include(task)
        expect(Task.search_task_name('テスト')).not_to include(second_task)
        expect(Task.search_task_name('テスト').count).to eq 1
      end
    end
    context 'scopeメソッドでステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        expect(Task.search_status('未着手')).to include(task)
        expect(Task.search_status('未着手')).not_to include(second_task)
        expect(Task.search_status('未着手').count).to eq 1
      end
    end
    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        expect(Task.search_task_name('テスト').search_status('未着手')).to include(task)
        expect(Task.search_task_name('テスト').search_status('未着手')).not_to include(second_task)
        expect(Task.search_task_name('テスト').search_status('未着手').count).to eq 1
      end
    end
  end
end
