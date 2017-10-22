defmodule MemoWeb.EntryView do
  use MemoWeb, :view

  def job_progress_string(nil),
    do: ""
  def job_progress_string(percentage),
    do: "#{round(percentage * 100)}%"
end
