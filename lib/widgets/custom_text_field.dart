import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_dimensions.dart';
import '/core/theme/app_theme.dart';
import '/core/theme/app_text_styles.dart';
import '/core/theme/app_colors.dart';
enum CustomTextFieldType {
  text,
  email,
  password,
  phone,
  number,
  multiline,
}

class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final CustomTextFieldType type;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final void Function()? onEditingComplete;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final String? suffixText;
  final Color? fillColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? contentPadding;
  final BorderRadius? borderRadius;
  final bool showCounter;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;

  const CustomTextField({
    super.key,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.type = CustomTextFieldType.text,
    this.controller,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onEditingComplete,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.fillColor,
    this.borderColor,
    this.contentPadding,
    this.borderRadius,
    this.showCounter = false,
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.type == CustomTextFieldType.password ? true : widget.obscureText;

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.inputLabel,
          ),
          const SizedBox(height: AppDimensions.spacing8),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          onEditingComplete: widget.onEditingComplete,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          maxLines: _getMaxLines(),
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          textInputAction: widget.textInputAction ?? _getTextInputAction(),
          textCapitalization: widget.textCapitalization,
          keyboardType: _getKeyboardType(),
          inputFormatters: widget.inputFormatters ?? _getInputFormatters(),
          obscureText: _obscureText,
          enableSuggestions: widget.enableSuggestions,
          autocorrect: widget.autocorrect,
          style: AppTextStyles.inputText,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTextStyles.inputHint,
            helperText: widget.helperText,
            helperStyle: AppTextStyles.bodySmall,
            errorText: widget.errorText,
            errorStyle: AppTextStyles.inputError,
            errorMaxLines: 2,
            filled: true,
            fillColor: widget.fillColor ?? AppColors.inputBackground,
            contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing16,
              vertical: AppDimensions.spacing16,
            ),
            prefixIcon: _buildPrefixIcon(),
            suffixIcon: _buildSuffixIcon(),
            prefixText: widget.prefixText,
            suffixText: widget.suffixText,
            prefixStyle: AppTextStyles.inputText,
            suffixStyle: AppTextStyles.inputText,
            counterText: widget.showCounter ? null : '',
            border: _buildBorder(),
            enabledBorder: _buildBorder(),
            focusedBorder: _buildFocusedBorder(),
            errorBorder: _buildErrorBorder(),
            focusedErrorBorder: _buildFocusedErrorBorder(),
            disabledBorder: _buildDisabledBorder(),
          ),
        ),
      ],
    );
  }

  Widget? _buildPrefixIcon() {
    if (widget.prefixIcon != null) {
      return widget.prefixIcon;
    }

    switch (widget.type) {
      case CustomTextFieldType.email:
        return const Icon(
          Icons.email_outlined,
          color: AppColors.inputHint,
        );
      case CustomTextFieldType.password:
        return const Icon(
          Icons.lock_outline,
          color: AppColors.inputHint,
        );
      case CustomTextFieldType.phone:
        return const Icon(
          Icons.phone_outlined,
          color: AppColors.inputHint,
        );
      default:
        return null;
    }
  }

  Widget? _buildSuffixIcon() {
    if (widget.type == CustomTextFieldType.password) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.inputHint,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    if (widget.suffixIcon != null) {
      return widget.suffixIcon;
    }

    return null;
  }

  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(AppDimensions.radiusMedium),
      borderSide: BorderSide(
        color: widget.borderColor ?? AppColors.inputBorder,
        width: 1,
      ),
    );
  }

  OutlineInputBorder _buildFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(AppDimensions.radiusMedium),
      borderSide: const BorderSide(
        color: AppColors.inputBorderActive,
        width: 2,
      ),
    );
  }

  OutlineInputBorder _buildErrorBorder() {
    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(AppDimensions.radiusMedium),
      borderSide: const BorderSide(
        color: AppColors.error,
        width: 1,
      ),
    );
  }

  OutlineInputBorder _buildFocusedErrorBorder() {
    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(AppDimensions.radiusMedium),
      borderSide: const BorderSide(
        color: AppColors.error,
        width: 2,
      ),
    );
  }

  OutlineInputBorder _buildDisabledBorder() {
    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(AppDimensions.radiusMedium),
      borderSide: BorderSide(
        color: AppColors.inputBorder.withAlpha(128),
        width: 1,
      ),
    );
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case CustomTextFieldType.email:
        return TextInputType.emailAddress;
      case CustomTextFieldType.password:
        return TextInputType.visiblePassword;
      case CustomTextFieldType.phone:
        return TextInputType.phone;
      case CustomTextFieldType.number:
        return TextInputType.number;
      case CustomTextFieldType.multiline:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  TextInputAction _getTextInputAction() {
    switch (widget.type) {
      case CustomTextFieldType.multiline:
        return TextInputAction.newline;
      default:
        return TextInputAction.next;
    }
  }

  int? _getMaxLines() {
    if (widget.maxLines != null) {
      return widget.maxLines;
    }

    switch (widget.type) {
      case CustomTextFieldType.password:
        return 1;
      case CustomTextFieldType.multiline:
        return null;
      default:
        return 1;
    }
  }

  List<TextInputFormatter>? _getInputFormatters() {
    if (widget.inputFormatters != null) {
      return widget.inputFormatters;
    }

    switch (widget.type) {
      case CustomTextFieldType.phone:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(15),
        ];
      case CustomTextFieldType.number:
        return [
          FilteringTextInputFormatter.digitsOnly,
        ];
      case CustomTextFieldType.email:
        return [
          FilteringTextInputFormatter.deny(RegExp(r'\s')), // No spaces
        ];
      default:
        return null;
    }
  }
}

// Search Text Field
class SearchTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;

  const SearchTextField({
    super.key,
    this.hintText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: hintText ?? 'Search...',
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      autofocus: autofocus,
      textInputAction: TextInputAction.search,
      prefixIcon: const Icon(
        Icons.search,
        color: AppColors.inputHint,
      ),
      suffixIcon: controller?.text.isNotEmpty == true
          ? IconButton(
        icon: const Icon(
          Icons.clear,
          color: AppColors.inputHint,
        ),
        onPressed: () {
          controller?.clear();
          onClear?.call();
        },
      )
          : null,
    );
  }
}

// Pin Input Field
class PinInputField extends StatefulWidget {
  final int length;
  final void Function(String) onCompleted;
  final void Function(String)? onChanged;
  final bool obscureText;
  final TextInputType keyboardType;

  const PinInputField({
    super.key,
    this.length = 4,
    required this.onCompleted,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType = TextInputType.number,
  });

  @override
  State<PinInputField> createState() => _PinInputFieldState();
}

class _PinInputFieldState extends State<PinInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
          (index) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.length,
          (index) => FocusNode(),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 50,
          height: 60,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: widget.keyboardType,
            textAlign: TextAlign.center,
            maxLength: 1,
            obscureText: widget.obscureText,
            style: AppTextStyles.h4,
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: AppColors.inputBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                borderSide: const BorderSide(color: AppColors.inputBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                borderSide: const BorderSide(color: AppColors.inputBorderActive, width: 2),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (index < widget.length - 1) {
                  _focusNodes[index + 1].requestFocus();
                } else {
                  _focusNodes[index].unfocus();
                }
              } else if (index > 0) {
                _focusNodes[index - 1].requestFocus();
              }

              final pin = _controllers.map((c) => c.text).join();
              widget.onChanged?.call(pin);

              if (pin.length == widget.length) {
                widget.onCompleted(pin);
              }
            },
          ),
        );
      }),
    );
  }
}