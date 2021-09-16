class BooksController < ApplicationController
  before_action :authenticate_user!, 
    only: [:index, :new, :create, :destroy, :trash, :trashes_box, :recover_from_trashbox]

  def index
    @books = Book.where(user_id: current_user.id,is_deleted: false)
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to root_path
    else  
      flash.now[:error_book] = CREATE_BOOK_VALIDATION_ERROR
      render :new
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to root_path
  end

  def trash
    book = Book.find(params[:id])
    book.update(is_deleted: true)
    redirect_to root_path
  end

  def trashes_box
    @books = Book.where(user_id: current_user.id, is_deleted: true)
  end

  def recover_from_trashbox
    book = Book.find(params[:id])
    book.update(is_deleted: false)
    redirect_to root_path
  end


  private

  def book_params
    params
    .require(:book)
    .permit(:book_subject,:genre_id,:is_deleted)
    .merge(user_id: current_user.id)
  end
  
end
