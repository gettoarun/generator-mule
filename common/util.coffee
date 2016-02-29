module.exports.folderize = ( name ) ->
  # console.log "folderizing #{name}..."
  name.replace( /[^(a-zA-Z0-9 \-)+]/g, '').split(' ').join('-')
