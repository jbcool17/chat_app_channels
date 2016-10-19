var FormBox = React.createClass({
  handleCommentSubmit: function(data) {
    console.log('handleCommentSubmit', data.url, data.user)
    
    $.ajax({
      url: data.url,
      dataType: 'text',
      type: 'POST',
      data: data,
      success: function(date) {
        // console.log(data)
        window.location.pathname = "/mr/chat/" + data.user;
      },
      error: function(xhr, status, err) {
        console.error(data.url, status, err.toString());
      }
    });
  },
  getInitialState: function() {
    return {data: []};
  },
  render: function() {
    return (
      <div className="commentBox">
        <UserForm url="/mr/user"onCommentSubmit={this.handleCommentSubmit} />
        <br/>
        <UserForm url="/lr/user"onCommentSubmit={this.handleCommentSubmit} />
        <br/>
        <UserForm url="/ws"onCommentSubmit={this.handleCommentSubmit} />    
      </div>
    );
  }
});


var UserForm = React.createClass({
  getInitialState: function() {
    return {user: ''};
  },
  handleChange: function(e) {
    this.setState({user: e.target.value});
  },
  handleSubmit: function(e) {
    e.preventDefault();
    var user = this.state.user.trim();
    if (!user) {
      return;
    }
      
    console.log(user, this.props.url)
    this.props.onCommentSubmit({user: user, url: this.props.url});
    this.setState({user: ''});
  },
  render: function() {
    return (
      <form className="userForm" action={this.props.url} onSubmit={this.handleSubmit} method="post">
        <label>USER: </label>
          <input
          type="text"
          placeholder="Enter user name."
          value={this.state.user}
          onChange={this.handleChange}
        />
          <input className="btn btn-sm btn-primary" type="submit" onChange={this.handleSubmit}/>
      </form> 
    );
  }
});

ReactDOM.render(
  <FormBox/>,
  document.getElementById('content')
);